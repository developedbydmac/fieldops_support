# ====================================
# API MANAGEMENT MODULE - VARIABLES
# ====================================
# Day-4: API Management (Developer tier) for FieldOps Support AI API gateway

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "location" {
  description = "Azure region for API Management deployment"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for API Management resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all API Management resources"
  type        = map(string)
  default     = {}
}

variable "publisher_name" {
  description = "Name of the API publisher organization"
  type        = string
  default     = "Unknown Ops"
}

variable "publisher_email" {
  description = "Email address of the API publisher"
  type        = string
  default     = "ops@example.com"
}

variable "law_id" {
  description = "Log Analytics workspace ID for diagnostic settings"
  type        = string
}
