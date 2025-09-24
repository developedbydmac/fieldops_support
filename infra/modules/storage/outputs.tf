# =============================================================================
# STORAGE MODULE - OUTPUTS
# FieldOps Support AI - Day-3 Storage Module
# =============================================================================

# =============================================================================
# STORAGE ACCOUNT OUTPUTS
# =============================================================================

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.sa.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.sa.name
}

output "storage_primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "storage_primary_web_endpoint" {
  description = "The primary web endpoint of the storage account"
  value       = azurerm_storage_account.sa.primary_web_endpoint
}

output "storage_primary_access_key" {
  description = "The primary access key of the storage account"
  value       = azurerm_storage_account.sa.primary_access_key
  sensitive   = true
}

output "storage_secondary_access_key" {
  description = "The secondary access key of the storage account"
  value       = azurerm_storage_account.sa.secondary_access_key
  sensitive   = true
}

output "storage_primary_connection_string" {
  description = "The primary connection string of the storage account"
  value       = azurerm_storage_account.sa.primary_connection_string
  sensitive   = true
}

output "storage_account_tier" {
  description = "The tier of the storage account"
  value       = azurerm_storage_account.sa.account_tier
}

output "storage_replication_type" {
  description = "The replication type of the storage account"
  value       = azurerm_storage_account.sa.account_replication_type
}

# =============================================================================
# STORAGE CONTAINER OUTPUTS
# =============================================================================

output "logs_container_name" {
  description = "The name of the logs container"
  value       = azurerm_storage_container.logs.name
}

output "logs_container_id" {
  description = "The ID of the logs container"
  value       = azurerm_storage_container.logs.id
}

output "backups_container_name" {
  description = "The name of the backups container"
  value       = azurerm_storage_container.backups.name
}

output "uploads_container_name" {
  description = "The name of the uploads container"
  value       = azurerm_storage_container.uploads.name
}

# =============================================================================
# MANAGED IDENTITY OUTPUT
# =============================================================================

output "storage_account_identity" {
  description = "The system-assigned managed identity of the storage account"
  value = {
    principal_id = azurerm_storage_account.sa.identity[0].principal_id
    tenant_id    = azurerm_storage_account.sa.identity[0].tenant_id
    type         = azurerm_storage_account.sa.identity[0].type
  }
}

# =============================================================================
# SUMMARY OUTPUT
# =============================================================================

output "storage_summary" {
  description = "Summary of storage account deployment"
  value = {
    account_name           = azurerm_storage_account.sa.name
    primary_blob_endpoint  = azurerm_storage_account.sa.primary_blob_endpoint
    account_tier          = azurerm_storage_account.sa.account_tier
    replication_type      = azurerm_storage_account.sa.account_replication_type
    https_traffic_only    = azurerm_storage_account.sa.https_traffic_only_enabled
    min_tls_version       = azurerm_storage_account.sa.min_tls_version
    containers = {
      logs    = azurerm_storage_container.logs.name
      backups = azurerm_storage_container.backups.name
      uploads = azurerm_storage_container.uploads.name
    }
    managed_identity = {
      principal_id = azurerm_storage_account.sa.identity[0].principal_id
      tenant_id    = azurerm_storage_account.sa.identity[0].tenant_id
    }
  }
}
