# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.name_prefix}-${var.environment}"
  location = var.location

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# Random password for PostgreSQL
resource "random_password" "postgres_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# TODO: Day 2 - VNet and Subnets
# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.name_prefix}-${var.environment}"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# App Subnet
resource "azurerm_subnet" "app" {
  name                 = "snet-app-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.app_subnet_address_prefixes

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Data Subnet
resource "azurerm_subnet" "data" {
  name                 = "snet-data-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.data_subnet_address_prefixes
  
  delegation {
    name = "PostgreSQL-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Private Endpoints Subnet
resource "azurerm_subnet" "pe" {
  name                 = "snet-pe-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.pe_subnet_address_prefixes
}

# Network Security Groups
resource "azurerm_network_security_group" "app" {
  name                = "nsg-app-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

# TODO: Day 3 - PostgreSQL Flexible Server
# Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "postgres" {
  name                = "${var.name_prefix}-${var.environment}.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-vnet-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "psql-${var.name_prefix}-${var.environment}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = var.postgres_version
  delegated_subnet_id    = azurerm_subnet.data.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres.id
  administrator_login    = var.postgres_admin_username
  administrator_password = random_password.postgres_password.result
  zone                   = "1"
  
  # Disable public access when using VNet integration
  public_network_access_enabled = false
  
  storage_mb = var.postgres_storage_mb
  sku_name   = var.postgres_sku_name

  tags = merge(var.tags, {
    Environment = var.environment
  })

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "fieldops_db"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# TODO: Day 3 - Storage Account
resource "azurerm_storage_account" "logs" {
  name                     = "st${var.name_prefix}logs${var.environment}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  blob_properties {
    versioning_enabled = true
  }

  tags = merge(var.tags, {
    Environment = var.environment
    Purpose     = "Logs"
  })
}

resource "azurerm_storage_container" "logs" {
  name                  = "application-logs"
  storage_account_name  = azurerm_storage_account.logs.name
  container_access_type = "private"
}

# TODO: Day 4 - Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.name_prefix}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# TODO: Day 4 - App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.name_prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# TODO: Day 4 - App Service
resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.name_prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false
    application_stack {
      python_version = "3.9"
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "POSTGRES_HOST"                       = azurerm_postgresql_flexible_server.main.fqdn
    "POSTGRES_DB"                         = azurerm_postgresql_flexible_server_database.main.name
    "POSTGRES_USER"                       = var.postgres_admin_username
    # Password will be stored in Key Vault
  }

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# TODO: Day 4 - API Management
resource "azurerm_api_management" "main" {
  name                = "apim-${var.name_prefix}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# TODO: Day 5 - Key Vault
resource "azurerm_key_vault" "main" {
  name                        = "kv-${var.name_prefix}-${var.environment}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  tags = merge(var.tags, {
    Environment = var.environment
  })
}

data "azurerm_client_config" "current" {}

# Key Vault Access Policy for current user/service principal
resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover",
    "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey",
    "Verify", "Sign", "Purge"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
}

# Store PostgreSQL password in Key Vault
resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-admin-password"
  value        = random_password.postgres_password.result
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.current]

  tags = merge(var.tags, {
    Environment = var.environment
  })
}
