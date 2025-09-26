# =============================================================================
# INFRASTRUCTURE OUTPUTS
# FieldOps Support AI - Day-3 Modular Architecture
# =============================================================================

# =============================================================================
# RESOURCE GROUP OUTPUTS
# =============================================================================

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# =============================================================================
# NETWORK MODULE OUTPUTS (Day-2)
# =============================================================================

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "app_subnet_id" {
  description = "ID of the application subnet"
  value       = module.network.subnet_app_id
}

output "data_subnet_id" {
  description = "ID of the data subnet"
  value       = module.network.subnet_data_id
}

output "pe_subnet_id" {
  description = "ID of the private endpoints subnet"
  value       = module.network.subnet_pe_id
}

output "network_summary" {
  description = "Summary of network configuration"
  value       = module.network.network_summary
}

# =============================================================================
# STORAGE MODULE OUTPUTS (Day-3)
# =============================================================================

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "storage_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = module.storage.storage_primary_blob_endpoint
}

output "logs_container_name" {
  description = "Name of the logs container"
  value       = module.storage.logs_container_name
}

output "storage_summary" {
  description = "Summary of storage deployment"
  value       = module.storage.storage_summary
}

# =============================================================================
# POSTGRESQL MODULE OUTPUTS (Day-3)
# =============================================================================

output "pg_fqdn" {
  description = "Private FQDN of PostgreSQL Flexible Server"
  value       = module.postgres.pg_fqdn
}

output "pg_db_name" {
  description = "Name of the PostgreSQL database"
  value       = module.postgres.pg_db_name
}

output "postgres_connection_info" {
  description = "PostgreSQL connection information"
  value       = module.postgres.connection_info
  sensitive   = false
}

output "postgres_summary" {
  description = "Summary of PostgreSQL deployment"
  value       = module.postgres.postgres_summary
}

# =============================================================================
# PRIVATE NETWORKING MODULE OUTPUTS (Day-3)
# =============================================================================

output "private_dns_zone_postgres_id" {
  description = "ID of the PostgreSQL private DNS zone"
  value       = module.private_net.pdz_postgres_id
}

output "private_dns_zone_blob_id" {
  description = "ID of the Blob Storage private DNS zone"
  value       = module.private_net.pdz_blob_id
}

output "private_endpoint_blob_id" {
  description = "ID of the Blob Storage private endpoint"
  value       = module.private_net.pe_blob_id
}

output "private_networking_summary" {
  description = "Summary of private networking deployment"
  value       = module.private_net.private_networking_summary
}

# =============================================================================
# DAY-5 KEY VAULT MODULE OUTPUTS
# =============================================================================

output "key_vault_uri" {
  description = "URI of the Key Vault for application configuration"
  value       = module.keyvault.key_vault_uri
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.key_vault_name
}

output "pg_secret_name" {
  description = "Name of the PostgreSQL connection string secret in Key Vault"
  value       = module.keyvault.pg_secret_name
}

output "web_app_principal_id" {
  description = "Principal ID of the Web App's system-assigned managed identity"
  value       = module.appsvc.web_app_principal_id
}

# =============================================================================
# LEGACY RESOURCE OUTPUTS (Day-1 Foundation)
# =============================================================================

# Legacy Key Vault (commented out - replaced by Day-5 module)
# output "legacy_key_vault_uri" {
#   description = "URI of the legacy Key Vault"
#   value       = azurerm_key_vault.main.vault_uri
# }

# =============================================================================
# DAY-4 MODULE OUTPUTS
# =============================================================================

# Observability Module Outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace (Day-4 module)"
  value       = module.observability.law_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace (Day-4 module)"
  value       = module.observability.law_name
}

# App Service Module Outputs
output "web_app_name" {
  description = "Name of the Web App"
  value       = module.appsvc.web_app_name
}

output "web_app_default_hostname" {
  description = "Default hostname of the Web App"
  value       = module.appsvc.web_app_default_hostname
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = module.appsvc.app_service_plan_name
}

# API Management Module Outputs
output "apim_name" {
  description = "Name of the API Management service"
  value       = module.apim.apim_name
}

output "apim_gateway_url" {
  description = "Gateway URL of the API Management service"
  value       = module.apim.apim_gateway_url
}

output "apim_developer_portal_url" {
  description = "Developer portal URL of the API Management service"
  value       = module.apim.apim_developer_portal_url
}
