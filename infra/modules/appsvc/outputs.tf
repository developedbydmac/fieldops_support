# ====================================
# APP SERVICE MODULE - OUTPUTS
# ====================================
# Day-4: App Service outputs for integration and monitoring

output "app_service_plan_id" {
  description = "Resource ID of the App Service Plan"
  value       = azurerm_service_plan.plan.id
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.plan.name
}

output "web_app_id" {
  description = "Resource ID of the Web App"
  value       = azurerm_linux_web_app.app.id
}

output "web_app_name" {
  description = "Name of the Web App"
  value       = azurerm_linux_web_app.app.name
}

output "web_app_default_hostname" {
  description = "Default hostname of the Web App"
  value       = azurerm_linux_web_app.app.default_hostname
}

output "web_app_identity_principal_id" {
  description = "Principal ID of the Web App's system-assigned managed identity"
  value       = azurerm_linux_web_app.app.identity[0].principal_id
}

# Alias for Key Vault integration
output "web_app_principal_id" {
  description = "System-assigned managed identity principal ID for RBAC assignments"
  value       = azurerm_linux_web_app.app.identity[0].principal_id
}
