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

# Network Variables
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "app_subnet_address_prefixes" {
  description = "Address prefixes for the app subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "data_subnet_address_prefixes" {
  description = "Address prefixes for the data subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "pe_subnet_address_prefixes" {
  description = "Address prefixes for the private endpoints subnet"
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
