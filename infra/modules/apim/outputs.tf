# ====================================
# API MANAGEMENT MODULE - OUTPUTS
# ====================================
# Day-4: API Management outputs for integration and access

output "apim_id" {
  description = "Resource ID of the API Management service"
  value       = azurerm_api_management.apim.id
}

output "apim_name" {
  description = "Name of the API Management service"
  value       = azurerm_api_management.apim.name
}

output "apim_gateway_url" {
  description = "Gateway URL of the API Management service"
  value       = azurerm_api_management.apim.gateway_url
}

output "apim_developer_portal_url" {
  description = "Developer portal URL of the API Management service"
  value       = azurerm_api_management.apim.developer_portal_url
}

output "apim_identity_principal_id" {
  description = "Principal ID of the API Management's system-assigned managed identity"
  value       = azurerm_api_management.apim.identity[0].principal_id
}
