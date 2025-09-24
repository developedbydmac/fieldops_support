# =============================================================================
# DAY-3 DEVELOPMENT ENVIRONMENT CONFIGURATION
# FieldOps Support AI - Modular Architecture
# =============================================================================

# Basic Configuration
location    = "eastus"
name_prefix = "fieldops"

# =============================================================================
# NETWORK CONFIGURATION (Day-2 Module)
# =============================================================================

vnet_cidr        = "10.20.0.0/16"
subnet_app_cidr  = "10.20.1.0/24"
subnet_data_cidr = "10.20.2.0/24"
subnet_pe_cidr   = "10.20.3.0/24"

# =============================================================================
# POSTGRESQL CONFIGURATION (Day-3 Module)
# =============================================================================

postgres_administrator_login = "fieldopsadmin"
postgres_database_name       = "fieldops"
postgres_server_sku_name     = "B_Standard_B1ms"
postgres_storage_mb_v2       = 32768
postgres_version_v2          = "16"

# =============================================================================
# STORAGE CONFIGURATION (Day-3 Module)
# =============================================================================

storage_account_tier     = "Standard"
storage_replication_type = "LRS"
storage_container_name   = "logs"

# =============================================================================
# PRIVATE NETWORKING CONFIGURATION (Day-3 Module)
# =============================================================================

enable_postgres_private_dns      = true
enable_storage_private_endpoints = true
enable_blob_private_endpoint     = true
enable_file_private_endpoint     = false

# =============================================================================
# LEGACY CONFIGURATION (Day-1 Foundation)
# =============================================================================

# Keep for backward compatibility during migration
postgres_sku_name    = "B_Standard_B1ms"
postgres_storage_mb  = 32768
apim_sku            = "Developer_1"
app_service_sku     = "F1"

# Development team contact
apim_publisher_name  = "FieldOps Dev Team"
apim_publisher_email = "dev-fieldops@company.com"

# =============================================================================
# RESOURCE TAGS
# =============================================================================

tags = {
  project     = "fieldops-support-ai"
  env         = "dev"
  owner       = "D-Mac"
  phase       = "Day-3"
  managed_by  = "terraform"
  cost_center = "engineering"
}
