# =============================================================================
# POSTGRES MODULE - VARIABLES
# FieldOps Support AI - Day-3 PostgreSQL Module
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

variable "delegated_subnet_id" {
  description = "Subnet delegated to Microsoft.DBforPostgreSQL/flexibleServers"
  type        = string
}

variable "server_sku_name" {
  description = "Flexible Server SKU (e.g., Standard_B1ms)"
  type        = string
  default     = "Standard_B1ms"
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
  default     = 32768
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "16"
}

variable "administrator_login" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "fieldopsadmin"
}

variable "administrator_password" {
  description = "Admin password (sensitive). Pass via TF_VAR or CLI, not tfvars in repo."
  type        = string
  sensitive   = true
  default     = null
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "fieldops"
}

variable "private_dns_zone_id" {
  description = "Private DNS zone for privatelink.postgres.database.azure.com"
  type        = string
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "high_availability" {
  description = "High availability mode (Disabled/ZoneRedundant/SameZone)"
  type        = string
  default     = "Disabled"
  
  validation {
    condition = contains(["Disabled", "ZoneRedundant", "SameZone"], var.high_availability)
    error_message = "High availability must be one of: Disabled, ZoneRedundant, SameZone"
  }
}

variable "zone" {
  description = "Availability Zone for the server"
  type        = string
  default     = "1"
}
