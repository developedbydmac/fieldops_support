# ====================================
# OBSERVABILITY MODULE - MAIN
# ====================================
# Day-4: Log Analytics workspace for centralized observability and monitoring
# Provides diagnostic target for App Service and API Management

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name_prefix}-log"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  # Retention and pricing configuration
  retention_in_days   = 30
  sku                 = "PerGB2018"
  
  # Enable internet ingestion and query for development
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  
  tags = var.tags
}
