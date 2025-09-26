# ====================================
# APP SERVICE MODULE - MAIN
# ====================================
# Day-4: App Service Plan and Linux Web App with diagnostic settings
# Provides compute platform for FieldOps Support AI application

# App Service Plan - Linux-based for Python application
resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  # Linux OS for Python runtime compatibility
  os_type  = "Linux"
  sku_name = var.plan_sku_size
  
  tags = var.tags
}

# Linux Web App - Placeholder for FieldOps Support AI application
resource "azurerm_linux_web_app" "app" {
  name                = "${var.name_prefix}-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  
  # Security configuration
  https_only = true
  
  # Application configuration
  site_config {
    # Security settings
    minimum_tls_version = "1.2"
    ftps_state         = "Disabled"
    
    # Health monitoring
    health_check_path = "/healthz"
    
    # Runtime configuration - Python 3.12 for AI/ML compatibility
    application_stack {
      python_version = "3.12"
    }
    
    # Enable detailed error pages for development (auto-managed)
  }
  
  # Managed identity for secure Azure service access
  identity {
    type = "SystemAssigned"
  }
  
  # Application settings (placeholder - no secrets)
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "PYTHONPATH"                          = "/home/site/wwwroot"
  }
  
  tags = var.tags
}

# Diagnostic Settings - App Service → Log Analytics
resource "azurerm_monitor_diagnostic_setting" "app_diag" {
  name                       = "${var.name_prefix}-app-diag"
  target_resource_id         = azurerm_linux_web_app.app.id
  log_analytics_workspace_id = var.law_id
  
  # Application logs
  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  
  enabled_log {
    category = "AppServiceConsoleLogs"
  }
  
  enabled_log {
    category = "AppServiceAppLogs"
  }
  
  enabled_log {
    category = "AppServiceAuditLogs"
  }
  
  # Platform logs
  enabled_log {
    category = "AppServicePlatformLogs"
  }
  
  # Metrics
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
