# =============================================================================
# NETWORK MODULE OUTPUTS
# FieldOps Support AI - Day-2 Network Module
# =============================================================================

# =============================================================================
# VIRTUAL NETWORK OUTPUTS
# =============================================================================

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "The address space of the Virtual Network"
  value       = azurerm_virtual_network.main.address_space
}

output "vnet_location" {
  description = "The location of the Virtual Network"
  value       = azurerm_virtual_network.main.location
}

# =============================================================================
# SUBNET OUTPUTS
# =============================================================================

output "subnet_app_id" {
  description = "The ID of the application subnet"
  value       = azurerm_subnet.app.id
}

output "subnet_app_name" {
  description = "The name of the application subnet"
  value       = azurerm_subnet.app.name
}

output "subnet_app_address_prefixes" {
  description = "The address prefixes of the application subnet"
  value       = azurerm_subnet.app.address_prefixes
}

output "subnet_data_id" {
  description = "The ID of the data subnet"
  value       = azurerm_subnet.data.id
}

output "subnet_data_name" {
  description = "The name of the data subnet"
  value       = azurerm_subnet.data.name
}

output "subnet_data_address_prefixes" {
  description = "The address prefixes of the data subnet"
  value       = azurerm_subnet.data.address_prefixes
}

output "subnet_pe_id" {
  description = "The ID of the private endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output "subnet_pe_name" {
  description = "The name of the private endpoints subnet"
  value       = azurerm_subnet.pe.name
}

output "subnet_pe_address_prefixes" {
  description = "The address prefixes of the private endpoints subnet"
  value       = azurerm_subnet.pe.address_prefixes
}

# =============================================================================
# NETWORK SECURITY GROUP OUTPUTS
# =============================================================================

output "nsg_app_id" {
  description = "The ID of the application subnet NSG"
  value       = azurerm_network_security_group.app.id
}

output "nsg_data_id" {
  description = "The ID of the data subnet NSG"
  value       = azurerm_network_security_group.data.id
}

output "nsg_pe_id" {
  description = "The ID of the private endpoints subnet NSG"
  value       = azurerm_network_security_group.pe.id
}

# =============================================================================
# NETWORKING SUMMARY (for documentation and troubleshooting)
# =============================================================================

output "network_summary" {
  description = "Summary of network configuration for documentation"
  value = {
    vnet_name          = azurerm_virtual_network.main.name
    vnet_cidr          = var.vnet_cidr
    app_subnet_cidr    = var.subnet_app_cidr
    data_subnet_cidr   = var.subnet_data_cidr
    pe_subnet_cidr     = var.subnet_pe_cidr
    location           = var.location
    ddos_protection    = var.enable_ddos_protection
  }
}
