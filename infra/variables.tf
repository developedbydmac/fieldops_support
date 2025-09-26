variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "fieldops"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "FieldOps Support AI"
    Phase       = "1-IaC"
    ManagedBy   = "Terraform"
  }
}

# =============================================================================
# NETWORK VARIABLES (Day-2 Module Integration)
# =============================================================================

variable "vnet_cidr" {
  description = "CIDR block for the Virtual Network"
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_app_cidr" {
  description = "CIDR block for the application subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "subnet_data_cidr" {
  description = "CIDR block for the data subnet"
  type        = string
  default     = "10.20.2.0/24"
}

variable "subnet_pe_cidr" {
  description = "CIDR block for the private endpoints subnet"
  type        = string
  default     = "10.20.3.0/24"
}

# Legacy network variables (to be deprecated after migration)
variable "vnet_address_space" {
  description = "DEPRECATED: Use vnet_cidr instead"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "app_subnet_address_prefixes" {
  description = "DEPRECATED: Use subnet_app_cidr instead"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "data_subnet_address_prefixes" {
  description = "DEPRECATED: Use subnet_data_cidr instead"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "pe_subnet_address_prefixes" {
  description = "DEPRECATED: Use subnet_pe_cidr instead"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

# Database Variables
variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
  default     = "fieldopsadmin"
}

variable "postgres_sku_name" {
  description = "SKU name for PostgreSQL Flexible Server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "Storage size in MB for PostgreSQL"
  type        = number
  default     = 32768
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "13"
}

# APIM Variables
variable "apim_sku" {
  description = "SKU for API Management"
  type        = string
  default     = "Developer_1"
}

variable "apim_publisher_name" {
  description = "Publisher name for APIM"
  type        = string
  default     = "FieldOps Team"
}

variable "apim_publisher_email" {
  description = "Publisher email for APIM"
  type        = string
  default     = "fieldops@company.com"
}

# App Service Variables
variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "B1"
}

# =============================================================================
# DAY-3 MODULE VARIABLES
# =============================================================================

variable "resource_group_name_override" {
  description = "Optional: use an existing RG name; otherwise RG is created."
  type        = string
  default     = null
}

# PostgreSQL Variables (Day-3)
variable "postgres_administrator_login" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "fieldopsadmin"
}

variable "postgres_administrator_password" {
  description = "PostgreSQL administrator password (sensitive). Pass via TF_VAR or CLI, not tfvars in repo."
  type        = string
  sensitive   = true
  default     = null
}

variable "postgres_database_name" {
  description = "Name of the PostgreSQL database to create"
  type        = string
  default     = "fieldops"
}

variable "postgres_server_sku_name" {
  description = "PostgreSQL Flexible Server SKU name"
  type        = string
  default     = "Standard_B1ms"
}

variable "postgres_storage_mb_v2" {
  description = "PostgreSQL storage size in MB (Day-3)"
  type        = number
  default     = 32768
}

variable "postgres_version_v2" {
  description = "PostgreSQL version (Day-3)"
  type        = string
  default     = "16"
}

# Storage Variables (Day-3)
variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "storage_container_name" {
  description = "Name of the primary storage container"
  type        = string
  default     = "logs"
}

# Private Networking Variables (Day-3)
variable "enable_postgres_private_dns" {
  description = "Enable private DNS zone for PostgreSQL"
  type        = bool
  default     = true
}

variable "enable_storage_private_endpoints" {
  description = "Enable private endpoints for storage services"
  type        = bool
  default     = true
}

variable "enable_blob_private_endpoint" {
  description = "Enable private endpoint for blob storage"
  type        = bool
  default     = true
}

variable "enable_file_private_endpoint" {
  description = "Enable private endpoint for file storage"
  type        = bool
  default     = false
}

# =============================================================================
# DAY-4 OBSERVABILITY & APP SERVICE VARIABLES
# =============================================================================

# Publisher information for API Management (Day-4)
variable "publisher_name" {
  description = "Name of the API publisher organization"
  type        = string
  default     = "FieldOps AI"
}

variable "publisher_email" {
  description = "Email address of the API publisher"
  type        = string
  default     = "support@example.com"
}

# App Service Plan configuration (Day-4)
variable "app_service_plan_sku_tier" {
  description = "App Service Plan SKU tier (Basic, Standard, Premium, PremiumV2, PremiumV3)"
  type        = string
  default     = "Standard"
}

variable "app_service_plan_sku_size" {
  description = "App Service Plan SKU size (B1, S1, P1v3, etc.)"
  type        = string
  default     = "S1"
}

# =============================================================================
# DAY-5 KEY VAULT VARIABLES
# =============================================================================

variable "kv_pg_secret_name" {
  description = "Name for PostgreSQL connection string secret in Key Vault"
  type        = string
  default     = "pg-conn"
}

variable "create_pg_secret" {
  description = "Whether to create PostgreSQL connection string secret in Key Vault"
  type        = bool
  default     = true
}
