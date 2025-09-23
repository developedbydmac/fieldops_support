environment = "prod"
location    = "East US"
name_prefix = "fieldops"

# TODO: Configure production-specific values
# Production should have high availability and scale

vnet_address_space           = ["10.2.0.0/16"]
app_subnet_address_prefixes  = ["10.2.1.0/24"]
data_subnet_address_prefixes = ["10.2.2.0/24"]
pe_subnet_address_prefixes   = ["10.2.3.0/24"]

# Production sizes
postgres_sku_name    = "GP_Standard_D4s_v3"
postgres_storage_mb  = 131072
apim_sku            = "Standard_2"
app_service_sku     = "P1v2"

# Production team contact
apim_publisher_name  = "FieldOps Production Team"
apim_publisher_email = "prod-fieldops@company.com"

tags = {
  Project     = "FieldOps Support AI"
  Phase       = "1-IaC"
  Environment = "prod"
  ManagedBy   = "Terraform"
  Owner       = "Platform Team"
  CriticalityLevel = "High"
}
