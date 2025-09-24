# =============================================================================
# POSTGRES MODULE - OUTPUTS
# FieldOps Support AI - Day-3 PostgreSQL Module
# =============================================================================

# =============================================================================
# POSTGRESQL FLEXIBLE SERVER OUTPUTS
# =============================================================================

output "pg_id" {
  description = "The ID of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.pg.id
}

output "pg_name" {
  description = "The name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.pg.name
}

output "pg_fqdn" {
  description = "Private FQDN of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.pg.fqdn
  sensitive   = false
}

output "pg_administrator_login" {
  description = "Administrator login name"
  value       = azurerm_postgresql_flexible_server.pg.administrator_login
}

output "pg_version" {
  description = "PostgreSQL version"
  value       = azurerm_postgresql_flexible_server.pg.version
}

output "pg_sku_name" {
  description = "SKU name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.pg.sku_name
}

output "pg_storage_mb" {
  description = "Storage size in MB"
  value       = azurerm_postgresql_flexible_server.pg.storage_mb
}

# =============================================================================
# DATABASE OUTPUTS
# =============================================================================

output "pg_db_id" {
  description = "The ID of the PostgreSQL database"
  value       = azurerm_postgresql_flexible_server_database.db.id
}

output "pg_db_name" {
  description = "The name of the PostgreSQL database"
  value       = azurerm_postgresql_flexible_server_database.db.name
}

# =============================================================================
# CONNECTION INFORMATION
# =============================================================================

output "connection_info" {
  description = "PostgreSQL connection information"
  value = {
    server_fqdn    = azurerm_postgresql_flexible_server.pg.fqdn
    database_name  = azurerm_postgresql_flexible_server_database.db.name
    admin_username = azurerm_postgresql_flexible_server.pg.administrator_login
    port          = 5432
    ssl_mode      = "require"
  }
  sensitive = false
}

# =============================================================================
# SUMMARY OUTPUT
# =============================================================================

output "postgres_summary" {
  description = "Summary of PostgreSQL deployment"
  value = {
    server_name     = azurerm_postgresql_flexible_server.pg.name
    server_fqdn     = azurerm_postgresql_flexible_server.pg.fqdn
    database_name   = azurerm_postgresql_flexible_server_database.db.name
    version         = azurerm_postgresql_flexible_server.pg.version
    sku_name        = azurerm_postgresql_flexible_server.pg.sku_name
    storage_mb      = azurerm_postgresql_flexible_server.pg.storage_mb
    backup_retention = azurerm_postgresql_flexible_server.pg.backup_retention_days
    high_availability = var.high_availability
    private_access    = true
  }
}
