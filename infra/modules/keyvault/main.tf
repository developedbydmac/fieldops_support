# Key Vault Module - Main Configuration
# FieldOps Support AI - Day-5

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Azure Key Vault with RBAC model, soft-delete and purge protection
resource "azurerm_key_vault" "kv" {
  name                       = replace("${var.name_prefix}-kv", "-", "")
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id

  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  # Use RBAC authorization (no access_policies managed here)
  enable_rbac_authorization  = var.enable_rbac_authorization

  public_network_access_enabled = true

  tags = var.tags
}

# RBAC: Grant the web app identity the "Key Vault Secrets User" role on this vault
# Role definition ID for "Key Vault Secrets User"
locals {
  role_kv_secrets_user = "4633458b-17de-4a8f-8f48-4f6f9ceae4a8"
}

resource "azurerm_role_assignment" "kv_reader" {
  scope                = azurerm_key_vault.kv.id
  role_definition_id   = "/providers/Microsoft.Authorization/roleDefinitions/${local.role_kv_secrets_user}"
  principal_id         = var.reader_principal_id
  depends_on           = [azurerm_key_vault.kv]
}

# PostgreSQL connection string secret (created conditionally)
locals {
  pg_conn_string = var.create_pg_secret && var.pg_admin_password != null ? "Host=${var.pg_server_fqdn};Database=${var.pg_database};Username=${var.pg_admin_user};Password=${var.pg_admin_password};SslMode=Require" : ""
}

resource "azurerm_key_vault_secret" "pg_conn" {
  count        = var.create_pg_secret && var.pg_admin_password != null ? 1 : 0
  name         = var.pg_secret_name
  value        = local.pg_conn_string
  key_vault_id = azurerm_key_vault.kv.id
  content_type = "text/plain"

  depends_on = [azurerm_role_assignment.kv_reader]
}
