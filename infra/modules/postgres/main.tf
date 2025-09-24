# =============================================================================
# POSTGRES MODULE - MAIN CONFIGURATION
# FieldOps Support AI - Day-3 PostgreSQL Module
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
# POSTGRESQL FLEXIBLE SERVER
# =============================================================================

resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = "${var.name_prefix}-pg"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  delegated_subnet_id    = var.delegated_subnet_id
  private_dns_zone_id    = var.private_dns_zone_id
  zone                   = var.zone

  # SKU Configuration
  sku_name               = var.server_sku_name
  storage_mb             = var.storage_mb
  storage_tier           = "P4"  # Premium SSD for better performance
  
  # Backup Configuration
  backup_retention_days  = var.backup_retention_days
  geo_redundant_backup_enabled = false  # Disabled for cost optimization in dev

  # High Availability Configuration
  dynamic "high_availability" {
    for_each = var.high_availability != "Disabled" ? [1] : []
    content {
      mode = var.high_availability
    }
  }

  # Authentication Configuration
  administrator_login          = var.administrator_login
  administrator_password       = var.administrator_password

  # Security Configuration
  public_network_access_enabled = false  # Private access only

  # Maintenance Window (optional - defaults to system managed)
  maintenance_window {
    day_of_week  = 0  # Sunday
    start_hour   = 2  # 2 AM
    start_minute = 0
  }

  tags = merge(var.tags, {
    Component = "Database"
    Purpose   = "PostgreSQL Flexible Server for FieldOps Support AI"
    Tier      = "Data"
  })

  lifecycle {
    ignore_changes = [
      # Ignore changes to zone if high availability is enabled
      # as Azure may change the zone configuration
      zone,
    ]
  }
}

# =============================================================================
# POSTGRESQL DATABASE
# =============================================================================

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.pg.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  # Prevent accidental deletion of the database
  lifecycle {
    prevent_destroy = true
  }
}

# =============================================================================
# POSTGRESQL CONFIGURATIONS (Optional)
# =============================================================================

# Optional: Configure PostgreSQL parameters for optimal performance
resource "azurerm_postgresql_flexible_server_configuration" "log_connections" {
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.pg.id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_disconnections" {
  name      = "log_disconnections"
  server_id = azurerm_postgresql_flexible_server.pg.id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "connection_throttling" {
  name      = "connection_throttling"
  server_id = azurerm_postgresql_flexible_server.pg.id
  value     = "on"
}
