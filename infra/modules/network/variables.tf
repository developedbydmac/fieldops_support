# =============================================================================
# NETWORK MODULE VARIABLES
# FieldOps Support AI - Day-2 Network Module
# =============================================================================

variable "name_prefix" {
  description = "Prefix for all network resource names"
  type        = string
  validation {
    condition     = length(var.name_prefix) <= 12
    error_message = "Name prefix must be 12 characters or less to avoid Azure naming limits."
  }
}

variable "location" {
  description = "Azure region for network resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy network resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all network resources"
  type        = map(string)
  default     = {}
}

# =============================================================================
# NETWORK ADDRESSING
# =============================================================================

variable "vnet_cidr" {
  description = "CIDR block for the Virtual Network"
  type        = string
  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0))
    error_message = "VNet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_app_cidr" {
  description = "CIDR block for the application subnet (App Services, Container Apps)"
  type        = string
  validation {
    condition     = can(cidrhost(var.subnet_app_cidr, 0))
    error_message = "App subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_data_cidr" {
  description = "CIDR block for the data subnet (PostgreSQL, databases)"
  type        = string
  validation {
    condition     = can(cidrhost(var.subnet_data_cidr, 0))
    error_message = "Data subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_pe_cidr" {
  description = "CIDR block for the private endpoints subnet (Storage, Key Vault, etc.)"
  type        = string
  validation {
    condition     = can(cidrhost(var.subnet_pe_cidr, 0))
    error_message = "Private endpoints subnet CIDR must be a valid IPv4 CIDR block."
  }
}

# =============================================================================
# OPTIONAL NETWORK FEATURES
# =============================================================================

variable "enable_ddos_protection" {
  description = "Enable DDoS Protection Standard (additional cost ~$2944/month)"
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "Custom DNS servers for the VNet (empty list uses Azure default)"
  type        = list(string)
  default     = []
}
