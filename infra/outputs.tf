# =============================================================================
# NETWORK OUTPUTS (Day-2 Module Integration)
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

# API Management Outputs
output "apim_gateway_url" {
  description = "Gateway URL for API Management"
  value       = azurerm_api_management.main.gateway_url
}

output "apim_name" {
  description = "Name of the API Management instance"
  value       = azurerm_api_management.main.name
}

# PostgreSQL Outputs
output "postgres_fqdn" {
  description = "FQDN of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgres_database_name" {
  description = "Name of the PostgreSQL database"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

# Storage Outputs
output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.logs.name
}

output "storage_account_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.logs.primary_blob_endpoint
}

# Key Vault Outputs
output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

# App Service Outputs
output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.main.name
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_linux_web_app.main.default_hostname
}

# Log Analytics Outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

# Resource Group Output
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}
