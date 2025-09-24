# =============================================================================
# PRIVATE NETWORKING MODULE - MAIN CONFIGURATION
# FieldOps Support AI - Day-3 Private Networking Module
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
# PRIVATE DNS ZONES
# =============================================================================

# Private DNS Zone for PostgreSQL Flexible Server
resource "azurerm_private_dns_zone" "pdz_postgres" {
  count               = var.enable_postgres_dns_zone ? 1 : 0
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private DNS resolution for PostgreSQL"
    Service   = "PostgreSQL"
  })
}

# Private DNS Zone for Blob Storage
resource "azurerm_private_dns_zone" "pdz_blob" {
  count               = var.enable_storage_dns_zones ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private DNS resolution for Blob Storage"
    Service   = "Storage"
  })
}

# Private DNS Zone for File Storage
resource "azurerm_private_dns_zone" "pdz_file" {
  count               = var.enable_storage_dns_zones && var.enable_file_private_endpoint ? 1 : 0
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private DNS resolution for File Storage"
    Service   = "Storage"
  })
}

# Private DNS Zone for Queue Storage
resource "azurerm_private_dns_zone" "pdz_queue" {
  count               = var.enable_storage_dns_zones && var.enable_queue_private_endpoint ? 1 : 0
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = var.resource_group_name
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private DNS resolution for Queue Storage"
    Service   = "Storage"
  })
}

# Private DNS Zone for Table Storage
resource "azurerm_private_dns_zone" "pdz_table" {
  count               = var.enable_storage_dns_zones && var.enable_table_private_endpoint ? 1 : 0
  name                = "privatelink.table.core.windows.net"
  resource_group_name = var.resource_group_name
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private DNS resolution for Table Storage"
    Service   = "Storage"
  })
}

# =============================================================================
# VIRTUAL NETWORK LINKS
# =============================================================================

# VNet Link for PostgreSQL DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "link_pg" {
  count                 = var.enable_postgres_dns_zone ? 1 : 0
  name                  = "${var.name_prefix}-pg-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pdz_postgres[0].name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "VNet link for PostgreSQL DNS resolution"
  })
}

# VNet Link for Blob Storage DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "link_blob" {
  count                 = var.enable_storage_dns_zones ? 1 : 0
  name                  = "${var.name_prefix}-blob-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pdz_blob[0].name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "VNet link for Blob Storage DNS resolution"
  })
}

# VNet Link for File Storage DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "link_file" {
  count                 = var.enable_storage_dns_zones && var.enable_file_private_endpoint ? 1 : 0
  name                  = "${var.name_prefix}-file-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pdz_file[0].name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "VNet link for File Storage DNS resolution"
  })
}

# =============================================================================
# PRIVATE ENDPOINTS
# =============================================================================

# Private Endpoint for Blob Storage
resource "azurerm_private_endpoint" "pe_blob" {
  count               = var.enable_blob_private_endpoint ? 1 : 0
  name                = "${var.name_prefix}-pe-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_pe_id
  
  private_service_connection {
    name                           = "${var.name_prefix}-pe-blob-conn"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.enable_storage_dns_zones ? [1] : []
    content {
      name                 = "blob-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.pdz_blob[0].id]
    }
  }
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private endpoint for Blob Storage"
    Service   = "Storage"
  })
}

# Private Endpoint for File Storage
resource "azurerm_private_endpoint" "pe_file" {
  count               = var.enable_file_private_endpoint ? 1 : 0
  name                = "${var.name_prefix}-pe-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_pe_id
  
  private_service_connection {
    name                           = "${var.name_prefix}-pe-file-conn"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.enable_storage_dns_zones && var.enable_file_private_endpoint ? [1] : []
    content {
      name                 = "file-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.pdz_file[0].id]
    }
  }
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private endpoint for File Storage"
    Service   = "Storage"
  })
}

# Private Endpoint for Queue Storage
resource "azurerm_private_endpoint" "pe_queue" {
  count               = var.enable_queue_private_endpoint ? 1 : 0
  name                = "${var.name_prefix}-pe-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_pe_id
  
  private_service_connection {
    name                           = "${var.name_prefix}-pe-queue-conn"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.enable_storage_dns_zones && var.enable_queue_private_endpoint ? [1] : []
    content {
      name                 = "queue-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.pdz_queue[0].id]
    }
  }
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private endpoint for Queue Storage"
    Service   = "Storage"
  })
}

# Private Endpoint for Table Storage
resource "azurerm_private_endpoint" "pe_table" {
  count               = var.enable_table_private_endpoint ? 1 : 0
  name                = "${var.name_prefix}-pe-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_pe_id
  
  private_service_connection {
    name                           = "${var.name_prefix}-pe-table-conn"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.enable_storage_dns_zones && var.enable_table_private_endpoint ? [1] : []
    content {
      name                 = "table-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.pdz_table[0].id]
    }
  }
  
  tags = merge(var.tags, {
    Component = "Network"
    Purpose   = "Private endpoint for Table Storage"
    Service   = "Storage"
  })
}
