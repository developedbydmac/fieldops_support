environment = "stage"
location    = "East US"
name_prefix = "fieldops"

# TODO: Configure staging-specific values
# Staging should mirror production but with smaller scale

vnet_address_space           = ["10.1.0.0/16"]
app_subnet_address_prefixes  = ["10.1.1.0/24"]
data_subnet_address_prefixes = ["10.1.2.0/24"]
pe_subnet_address_prefixes   = ["10.1.3.0/24"]

# Medium sizes for staging
postgres_sku_name    = "GP_Standard_D2s_v3"
postgres_storage_mb  = 65536
apim_sku            = "Standard_1"
app_service_sku     = "S1"

# Staging team contact
apim_publisher_name  = "FieldOps Staging Team"
apim_publisher_email = "staging-fieldops@company.com"

tags = {
  Project     = "FieldOps Support AI"
  Phase       = "1-IaC"
  Environment = "stage"
  ManagedBy   = "Terraform"
  Owner       = "QA Team"
}
