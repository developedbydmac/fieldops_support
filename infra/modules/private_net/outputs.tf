# =============================================================================
# PRIVATE NETWORKING MODULE - OUTPUTS
# FieldOps Support AI - Day-3 Private Networking Module
# =============================================================================

# =============================================================================
# PRIVATE DNS ZONE OUTPUTS
# =============================================================================

output "pdz_postgres_id" {
  description = "The ID of the PostgreSQL private DNS zone"
  value       = var.enable_postgres_dns_zone ? azurerm_private_dns_zone.pdz_postgres[0].id : null
}

output "pdz_postgres_name" {
  description = "The name of the PostgreSQL private DNS zone"
  value       = var.enable_postgres_dns_zone ? azurerm_private_dns_zone.pdz_postgres[0].name : null
}

output "pdz_blob_id" {
  description = "The ID of the Blob Storage private DNS zone"
  value       = var.enable_storage_dns_zones ? azurerm_private_dns_zone.pdz_blob[0].id : null
}

output "pdz_blob_name" {
  description = "The name of the Blob Storage private DNS zone"
  value       = var.enable_storage_dns_zones ? azurerm_private_dns_zone.pdz_blob[0].name : null
}

output "pdz_file_id" {
  description = "The ID of the File Storage private DNS zone"
  value       = var.enable_storage_dns_zones && var.enable_file_private_endpoint ? azurerm_private_dns_zone.pdz_file[0].id : null
}

output "pdz_queue_id" {
  description = "The ID of the Queue Storage private DNS zone"
  value       = var.enable_storage_dns_zones && var.enable_queue_private_endpoint ? azurerm_private_dns_zone.pdz_queue[0].id : null
}

output "pdz_table_id" {
  description = "The ID of the Table Storage private DNS zone"
  value       = var.enable_storage_dns_zones && var.enable_table_private_endpoint ? azurerm_private_dns_zone.pdz_table[0].id : null
}

# =============================================================================
# PRIVATE ENDPOINT OUTPUTS
# =============================================================================

output "pe_blob_id" {
  description = "The ID of the Blob Storage private endpoint"
  value       = var.enable_blob_private_endpoint ? azurerm_private_endpoint.pe_blob[0].id : null
}

output "pe_blob_private_ip" {
  description = "The private IP address of the Blob Storage private endpoint"
  value       = var.enable_blob_private_endpoint ? azurerm_private_endpoint.pe_blob[0].private_service_connection[0].private_ip_address : null
}

output "pe_file_id" {
  description = "The ID of the File Storage private endpoint"
  value       = var.enable_file_private_endpoint ? azurerm_private_endpoint.pe_file[0].id : null
}

output "pe_file_private_ip" {
  description = "The private IP address of the File Storage private endpoint"
  value       = var.enable_file_private_endpoint ? azurerm_private_endpoint.pe_file[0].private_service_connection[0].private_ip_address : null
}

output "pe_queue_id" {
  description = "The ID of the Queue Storage private endpoint"
  value       = var.enable_queue_private_endpoint ? azurerm_private_endpoint.pe_queue[0].id : null
}

output "pe_table_id" {
  description = "The ID of the Table Storage private endpoint"
  value       = var.enable_table_private_endpoint ? azurerm_private_endpoint.pe_table[0].id : null
}

# =============================================================================
# VIRTUAL NETWORK LINK OUTPUTS
# =============================================================================

output "vnet_link_postgres_id" {
  description = "The ID of the PostgreSQL VNet link"
  value       = var.enable_postgres_dns_zone ? azurerm_private_dns_zone_virtual_network_link.link_pg[0].id : null
}

output "vnet_link_blob_id" {
  description = "The ID of the Blob Storage VNet link"
  value       = var.enable_storage_dns_zones ? azurerm_private_dns_zone_virtual_network_link.link_blob[0].id : null
}

output "vnet_link_file_id" {
  description = "The ID of the File Storage VNet link"
  value       = var.enable_storage_dns_zones && var.enable_file_private_endpoint ? azurerm_private_dns_zone_virtual_network_link.link_file[0].id : null
}

# =============================================================================
# SUMMARY OUTPUT
# =============================================================================

output "private_networking_summary" {
  description = "Summary of private networking deployment"
  value = {
    dns_zones = {
      postgres_enabled = var.enable_postgres_dns_zone
      postgres_zone    = var.enable_postgres_dns_zone ? azurerm_private_dns_zone.pdz_postgres[0].name : null
      blob_enabled     = var.enable_storage_dns_zones
      blob_zone        = var.enable_storage_dns_zones ? azurerm_private_dns_zone.pdz_blob[0].name : null
      file_enabled     = var.enable_storage_dns_zones && var.enable_file_private_endpoint
      file_zone        = var.enable_storage_dns_zones && var.enable_file_private_endpoint ? azurerm_private_dns_zone.pdz_file[0].name : null
    }
    private_endpoints = {
      blob_enabled    = var.enable_blob_private_endpoint
      blob_private_ip = var.enable_blob_private_endpoint ? azurerm_private_endpoint.pe_blob[0].private_service_connection[0].private_ip_address : null
      file_enabled    = var.enable_file_private_endpoint
      file_private_ip = var.enable_file_private_endpoint ? azurerm_private_endpoint.pe_file[0].private_service_connection[0].private_ip_address : null
      queue_enabled   = var.enable_queue_private_endpoint
      table_enabled   = var.enable_table_private_endpoint
    }
  }
}
