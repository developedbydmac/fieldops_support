# ====================================
# API MANAGEMENT MODULE - MAIN
# ====================================
# Day-4: API Management service (Developer tier) with diagnostic settings
# Provides API gateway and management capabilities for FieldOps Support AI

# API Management Service - Developer tier for development and testing
resource "azurerm_api_management" "apim" {
  name                = "${var.name_prefix}-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  # Publisher information (required)
  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email
  
  # Developer tier - cost-effective for development and testing
  sku_name = "Developer_1"
  
  # Managed identity for secure Azure service access
  identity {
    type = "SystemAssigned"
  }
  
  tags = var.tags
}

# Diagnostic Settings - API Management → Log Analytics
resource "azurerm_monitor_diagnostic_setting" "apim_diag" {
  name                       = "${var.name_prefix}-apim-diag"
  target_resource_id         = azurerm_api_management.apim.id
  log_analytics_workspace_id = var.law_id
  
  # Gateway logs for API request/response monitoring
  enabled_log {
    category = "GatewayLogs"
  }
  
  # WebSocket connection logs
  enabled_log {
    category = "WebSocketConnectionLogs"
  }
  
  # All metrics for performance monitoring
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
