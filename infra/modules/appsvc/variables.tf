# ====================================
# APP SERVICE MODULE - VARIABLES
# ====================================
# Day-4: App Service Plan and Web App for FieldOps Support AI application

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "location" {
  description = "Azure region for App Service deployment"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for App Service resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all App Service resources"
  type        = map(string)
  default     = {}
}

variable "law_id" {
  description = "Log Analytics workspace ID for diagnostic settings"
  type        = string
}

# App Service Plan configuration
variable "plan_sku_tier" {
  description = "App Service Plan SKU tier (Basic, Standard, Premium, PremiumV2, PremiumV3)"
  type        = string
  default     = "PremiumV3"
}

variable "plan_sku_size" {
  description = "App Service Plan SKU size (B1, S1, P1v3, etc.)"
  type        = string
  default     = "P1v3"
}
