# =============================================================================
# STORAGE MODULE - VARIABLES
# FieldOps Support AI - Day-3 Storage Module
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

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
  
  validation {
    condition = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be either 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
  
  validation {
    condition = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "container_name" {
  description = "Name of the storage container"
  type        = string
  default     = "logs"
}

variable "access_tier" {
  description = "Access tier for the storage account (Hot or Cool)"
  type        = string
  default     = "Hot"
  
  validation {
    condition = contains(["Hot", "Cool"], var.access_tier)
    error_message = "Access tier must be either 'Hot' or 'Cool'."
  }
}

variable "min_tls_version" {
  description = "Minimum TLS version for the storage account"
  type        = string
  default     = "TLS1_2"
  
  validation {
    condition = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "Minimum TLS version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS traffic only"
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items (containers, blobs) to be public"
  type        = bool
  default     = false
}

variable "allow_blob_public_access" {
  description = "Allow blob public access"
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Enable shared access key authentication"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true  # Set to false when using private endpoints only
}

variable "container_access_type" {
  description = "Access type for the storage container"
  type        = string
  default     = "private"
  
  validation {
    condition = contains(["blob", "container", "private"], var.container_access_type)
    error_message = "Container access type must be one of: blob, container, private."
  }
}
