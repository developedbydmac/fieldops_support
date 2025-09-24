environment = "dev"
location    = "East US"
name_prefix = "fieldops"

# =============================================================================
# DAY-2: NETWORK MODULE CONFIGURATION  
# =============================================================================

# Network addressing (Day-2 module-based approach)
vnet_cidr        = "10.20.0.0/16"
subnet_app_cidr  = "10.20.1.0/24"
subnet_data_cidr = "10.20.2.0/24"
subnet_pe_cidr   = "10.20.3.0/24"

# Legacy network configuration (deprecated)
vnet_address_space           = ["10.0.0.0/16"]
app_subnet_address_prefixes  = ["10.0.1.0/24"]
data_subnet_address_prefixes = ["10.0.2.0/24"]
pe_subnet_address_prefixes   = ["10.0.3.0/24"]

# Small sizes for development
postgres_sku_name    = "B_Standard_B1ms"
postgres_storage_mb  = 32768
apim_sku            = "Developer_1"
app_service_sku     = "F1"

# Development team contact
apim_publisher_name  = "FieldOps Dev Team"
apim_publisher_email = "dev-fieldops@company.com"

tags = {
  Project     = "FieldOps Support AI"
  Phase       = "1-IaC"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "Development Team"
}
