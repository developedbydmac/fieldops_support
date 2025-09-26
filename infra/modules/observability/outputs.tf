# ====================================
# OBSERVABILITY MODULE - OUTPUTS
# ====================================
# Day-4: Log Analytics workspace outputs for integration with other modules

output "law_id" {
  description = "Resource ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "law_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.law.name
}

output "law_workspace_id" {
  description = "Workspace ID (GUID) of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.law.workspace_id
}

output "law_primary_shared_key" {
  description = "Primary shared key for Log Analytics workspace (sensitive)"
  value       = azurerm_log_analytics_workspace.law.primary_shared_key
  sensitive   = true
}
