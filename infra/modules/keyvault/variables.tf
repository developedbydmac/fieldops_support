# Key Vault Module Variables
# FieldOps Support AI - Day-5

variable "name_prefix" {
  type        = string
  description = "Prefix for resource naming"
}

variable "location" {
  type        = string
  description = "Azure region for resource deployment"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for Key Vault deployment"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Enable RBAC authorization for Key Vault access"
  default     = true
}

# Principal to grant read access (system-assigned identity object/principal id)
variable "reader_principal_id" {
  type        = string
  description = "Principal ID (GUID) that should be able to read secrets (e.g., Web App managed identity)"
}

# Secret creation inputs
variable "create_pg_secret" {
  type        = bool
  description = "Whether to create PostgreSQL connection string secret"
  default     = true
}

variable "pg_secret_name" {
  type        = string
  description = "Name for the PostgreSQL connection string secret"
  default     = "pg-conn"
}

variable "pg_server_fqdn" {
  type        = string
  description = "PostgreSQL server FQDN"
}

variable "pg_database" {
  type        = string
  description = "PostgreSQL database name"
  default     = "fieldops"
}

variable "pg_admin_user" {
  type        = string
  description = "PostgreSQL admin username"
  default     = "fieldopsadmin"
}

variable "pg_admin_password" {
  type        = string
  sensitive   = true
  description = "PostgreSQL admin password (must be provided at apply time if create_pg_secret=true)"
  default     = null
}
