# =============================================================================
# PRIVATE NETWORKING MODULE - VARIABLES
# FieldOps Support AI - Day-3 Private Networking Module
# =============================================================================

variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID for DNS zone links"
  type        = string
}

variable "subnet_pe_id" {
  description = "Private Endpoint subnet ID"
  type        = string
}

# Target resource IDs for private endpoints
variable "storage_account_id" {
  description = "Storage Account ID for blob private endpoint"
  type        = string
}

variable "postgres_server_id" {
  description = "PostgreSQL Server ID (for reference, not used for PE)"
  type        = string
  default     = null
}

# Private endpoint configuration
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

variable "enable_queue_private_endpoint" {
  description = "Enable private endpoint for queue storage"
  type        = bool
  default     = false
}

variable "enable_table_private_endpoint" {
  description = "Enable private endpoint for table storage"
  type        = bool
  default     = false
}

# DNS zone configuration
variable "enable_postgres_dns_zone" {
  description = "Enable private DNS zone for PostgreSQL"
  type        = bool
  default     = true
}

variable "enable_storage_dns_zones" {
  description = "Enable private DNS zones for storage services"
  type        = bool
  default     = true
}
