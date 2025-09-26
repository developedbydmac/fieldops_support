# ====================================
# OBSERVABILITY MODULE - VARIABLES
# ====================================
# Day-4: Log Analytics workspace for centralized observability
# Provides foundation for diagnostic settings across all services

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "location" {
  description = "Azure region for Log Analytics workspace deployment"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for observability resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all observability resources"
  type        = map(string)
  default     = {}
}
