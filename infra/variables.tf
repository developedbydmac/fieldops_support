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
