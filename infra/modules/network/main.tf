# =============================================================================
# NETWORK MODULE - MAIN CONFIGURATION
# FieldOps Support AI - Day-2 Network Module
# =============================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

# =============================================================================
# VIRTUAL NETWORK
# =============================================================================

resource "azurerm_virtual_network" "main" {
  name                = "${var.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null

  # DDoS Protection (optional - significant cost)
  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection ? [1] : []
    content {
      id     = azurerm_network_ddos_protection_plan.main[0].id
      enable = true
    }
  }

  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "VNet for FieldOps Support AI services"
  })
}

# Optional DDoS Protection Plan
resource "azurerm_network_ddos_protection_plan" "main" {
  count               = var.enable_ddos_protection ? 1 : 0
  name                = "${var.name_prefix}-ddos-plan"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    Component = "Security"
    Purpose   = "DDoS Protection for production workloads"
  })
}

# =============================================================================
# NETWORK SECURITY GROUPS
# =============================================================================

# NSG for Application Subnet (App Services, Functions, Container Apps)
resource "azurerm_network_security_group" "app" {
  name                = "${var.name_prefix}-nsg-app"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTPS inbound from VNet (for health probes, inter-service communication)
  security_rule {
    name                       = "Allow-HTTPS-VNet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow HTTP inbound from VNet (for development and health checks)
  security_rule {
    name                       = "Allow-HTTP-VNet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow Azure Load Balancer health probes
  security_rule {
    name                       = "Allow-AzureLoadBalancer"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  # Allow all outbound (App Services need internet access for dependencies)
  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    Component = "Security"
    Purpose   = "Network security for application subnet"
  })
}

# NSG for Data Subnet (PostgreSQL, Redis, other data services)
resource "azurerm_network_security_group" "data" {
  name                = "${var.name_prefix}-nsg-data"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow PostgreSQL from VNet only
  security_rule {
    name                       = "Allow-PostgreSQL-VNet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow Redis from VNet only (future use)
  security_rule {
    name                       = "Allow-Redis-VNet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6379"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow VNet outbound only (no internet access for data services)
  security_rule {
    name                       = "Allow-VNet-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  # Deny internet outbound
  security_rule {
    name                       = "Deny-Internet-Outbound"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = merge(var.tags, {
    Component = "Security"
    Purpose   = "Network security for data subnet"
  })
}

# NSG for Private Endpoints Subnet
resource "azurerm_network_security_group" "pe" {
  name                = "${var.name_prefix}-nsg-pe"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTPS from VNet (private endpoint traffic)
  security_rule {
    name                       = "Allow-HTTPS-VNet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow Azure platform communication
  security_rule {
    name                       = "Allow-AzurePlatform"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    Component = "Security"
    Purpose   = "Network security for private endpoints"
  })
}

# =============================================================================
# SUBNETS
# =============================================================================

# Application Subnet (App Services, Container Apps, Functions)
resource "azurerm_subnet" "app" {
  name                 = "${var.name_prefix}-snet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_app_cidr]

  # Enable service endpoints for storage and key vault
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

# Data Subnet (PostgreSQL Flexible Server, Redis, etc.)
resource "azurerm_subnet" "data" {
  name                 = "${var.name_prefix}-snet-data"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_data_cidr]

  # Delegation for PostgreSQL Flexible Server
  delegation {
    name = "pg-flexible-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Private Endpoints Subnet
resource "azurerm_subnet" "pe" {
  name                 = "${var.name_prefix}-snet-pe"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_pe_cidr]

  # Disable network policies for private endpoints
  private_endpoint_network_policies = "Disabled"
}

# =============================================================================
# NSG ASSOCIATIONS
# =============================================================================

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.pe.id
}
