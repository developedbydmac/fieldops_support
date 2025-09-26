# =============================================================================
# MAIN INFRASTRUCTURE CONFIGURATION
# FieldOps Support AI - Day-3 Modular Architecture
# =============================================================================

# Provider configuration is in providers.tf

# =============================================================================
# LOCALS AND DATA SOURCES
# =============================================================================

locals {
  rg_name = coalesce(var.resource_group_name_override, "rg-${var.name_prefix}-${terraform.workspace}")
}

# =============================================================================
# RESOURCE GROUP
# =============================================================================

resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location

  tags = merge(var.tags, {
    Environment = terraform.workspace
    Phase       = "Day-3"
  })
}

# =============================================================================
# DAY-2: NETWORK MODULE
# =============================================================================

module "network" {
  source = "./modules/network"

  # Module configuration
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = terraform.workspace
  })

  # Network addressing
  vnet_cidr        = var.vnet_cidr
  subnet_app_cidr  = var.subnet_app_cidr
  subnet_data_cidr = var.subnet_data_cidr
  subnet_pe_cidr   = var.subnet_pe_cidr

  # Optional features (disabled for dev environment)
  enable_ddos_protection = false
  dns_servers           = []
}

# =============================================================================
# DAY-3: STORAGE MODULE
# =============================================================================

module "storage" {
  source = "./modules/storage"
  
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = terraform.workspace
  })

  # Storage configuration
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  container_name          = var.storage_container_name
}

# =============================================================================
# DAY-3: PRIVATE NETWORKING MODULE
# =============================================================================

module "private_net" {
  source = "./modules/private_net"
  
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_id             = module.network.vnet_id
  subnet_pe_id        = module.network.subnet_pe_id
  tags = merge(var.tags, {
    Environment = terraform.workspace
  })

  # Target resources for private endpoints
  storage_account_id = module.storage.storage_account_id
  postgres_server_id = null # PostgreSQL uses delegated subnet, not PE

  # Private endpoint configuration
  enable_blob_private_endpoint = var.enable_blob_private_endpoint
  enable_file_private_endpoint = var.enable_file_private_endpoint

  # DNS zone configuration
  enable_postgres_dns_zone = var.enable_postgres_private_dns
  enable_storage_dns_zones = var.enable_storage_private_endpoints
}

# =============================================================================
# DAY-3: POSTGRESQL MODULE
# =============================================================================

module "postgres" {
  source = "./modules/postgres"
  
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = terraform.workspace
  })

  # Network configuration
  delegated_subnet_id = module.network.subnet_data_id
  private_dns_zone_id = module.private_net.pdz_postgres_id

  # PostgreSQL configuration
  server_sku_name         = var.postgres_server_sku_name
  storage_mb              = var.postgres_storage_mb_v2
  postgres_version        = var.postgres_version_v2
  administrator_login     = var.postgres_administrator_login
  administrator_password  = var.postgres_administrator_password
  database_name           = var.postgres_database_name
}

# =============================================================================
# DAY-4: OBSERVABILITY MODULE
# =============================================================================

module "observability" {
  source = "./modules/observability"
  
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = terraform.workspace
    Phase       = "Day-4"
  })
}

# =============================================================================
# DAY-4: APP SERVICE MODULE
# =============================================================================

module "appsvc" {
  source = "./modules/appsvc"
  
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  law_id              = module.observability.law_id
  
  # App Service Plan configuration
  plan_sku_tier = var.app_service_plan_sku_tier
  plan_sku_size = var.app_service_plan_sku_size
  
  tags = merge(var.tags, {
    Environment = terraform.workspace
    Phase       = "Day-4"
  })
}

# =============================================================================
# DAY-4: API MANAGEMENT MODULE
# =============================================================================

module "apim" {
  source = "./modules/apim"
  
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  law_id              = module.observability.law_id
  
  # Publisher configuration
  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email
  
  tags = merge(var.tags, {
    Environment = terraform.workspace
    Phase       = "Day-4"
  })
}

# =============================================================================
# DAY-5: KEY VAULT MODULE
# =============================================================================

module "keyvault" {
  source = "./modules/keyvault"
  
  name_prefix         = "${var.name_prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = terraform.workspace
    Phase       = "Day-5"
  })

  # RBAC assignment for Web App system-assigned identity
  reader_principal_id = module.appsvc.web_app_principal_id

  # PostgreSQL connection string secret configuration
  create_pg_secret    = var.create_pg_secret
  pg_secret_name      = var.kv_pg_secret_name
  pg_server_fqdn      = module.postgres.pg_fqdn
  pg_database         = module.postgres.pg_db_name
  pg_admin_user       = var.postgres_administrator_login
  pg_admin_password   = var.postgres_administrator_password
}

# =============================================================================
# LEGACY RESOURCES (Day-1 Foundation)
# =============================================================================

# Log Analytics Workspace (Day-1 Legacy Resource)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.name_prefix}-${terraform.workspace}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(var.tags, {
    Environment = terraform.workspace
  })
}

# App Service Plan (Day-4 Future - commented out for quota issues)
# resource "azurerm_service_plan" "main" {
#   name                = "asp-${var.name_prefix}-${terraform.workspace}"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   os_type             = "Linux"
#   sku_name            = var.app_service_sku

#   tags = merge(var.tags, {
#     Environment = terraform.workspace
#   })
# }

# App Service (Day-4 Future - commented out for quota issues)
# resource "azurerm_linux_web_app" "main" {
#   name                = "app-${var.name_prefix}-${terraform.workspace}"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_service_plan.main.location
#   service_plan_id     = azurerm_service_plan.main.id

#   site_config {
#     always_on = false
#     application_stack {
#       python_version = "3.9"
#     }
#   }

#   app_settings = {
#     "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
#     "POSTGRES_HOST"                       = module.postgres.pg_fqdn
#     "POSTGRES_DB"                         = module.postgres.pg_db_name
#     "POSTGRES_USER"                       = var.postgres_administrator_login
#     # Password will be stored in Key Vault
#   }

#   tags = merge(var.tags, {
#     Environment = terraform.workspace
#   })
# }

# API Management (Day-4 Future - commented out for state management issues)
# resource "azurerm_api_management" "main" {
#   name                = "apim-${var.name_prefix}-${terraform.workspace}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   publisher_name      = var.apim_publisher_name
#   publisher_email     = var.apim_publisher_email
#   sku_name            = var.apim_sku

#   tags = merge(var.tags, {
#     Environment = terraform.workspace
#   })
# }

# Key Vault (Day-1 Legacy Resource)
resource "azurerm_key_vault" "main" {
  name                        = "kv-${var.name_prefix}-${terraform.workspace}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  tags = merge(var.tags, {
    Environment = terraform.workspace
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

# PostgreSQL Password Storage (Optional - only if using generated password)
# Note: For Day-3, password is passed via TF_VAR, not generated
# resource "random_password" "postgres_password" {
#   length  = 16
#   special = true
#   upper   = true
#   lower   = true
#   numeric = true
# }

# resource "azurerm_key_vault_secret" "postgres_password" {
#   name         = "postgres-admin-password"
#   value        = random_password.postgres_password.result
#   key_vault_id = azurerm_key_vault.main.id

#   depends_on = [azurerm_key_vault_access_policy.current]

#   tags = merge(var.tags, {
#     Environment = terraform.workspace
#   })
# }
