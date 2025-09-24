# =============================================================================
# STORAGE MODULE - MAIN CONFIGURATION
# FieldOps Support AI - Day-3 Storage Module
# =============================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

# =============================================================================
# STORAGE ACCOUNT
# =============================================================================

resource "azurerm_storage_account" "sa" {
  name                     = replace("${var.name_prefix}sa", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier

  # Security Configuration
  min_tls_version                 = var.min_tls_version
  https_traffic_only_enabled      = var.enable_https_traffic_only
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled

  # Advanced Threat Protection
  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "POST", "PUT"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }

    delete_retention_policy {
      days = 7
    }

    versioning_enabled       = true
    last_access_time_enabled = true
    change_feed_enabled      = true

    # Container soft delete
    container_delete_retention_policy {
      days = 7
    }
  }

  # Network Rules (can be customized based on requirements)
  network_rules {
    default_action             = "Allow"  # Change to "Deny" for private endpoint only access
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  # Identity for managed identity scenarios
  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, {
    Component = "Storage"
    Purpose   = "Application logs and data storage"
    Tier      = "Infrastructure"
  })

  lifecycle {
    # Prevent accidental deletion of storage account
    prevent_destroy = true
  }
}

# =============================================================================
# STORAGE CONTAINER
# =============================================================================

resource "azurerm_storage_container" "logs" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.container_access_type

  # Container metadata
  metadata = {
    environment = "dev"
    purpose     = "application-logs"
    created_by  = "terraform"
  }
}

# =============================================================================
# OPTIONAL: ADDITIONAL CONTAINERS
# =============================================================================

# Optional: Create additional containers for different purposes
resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"

  metadata = {
    environment = "dev"
    purpose     = "database-backups"
    created_by  = "terraform"
  }
}

resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"

  metadata = {
    environment = "dev"
    purpose     = "user-uploads"
    created_by  = "terraform"
  }
}

# =============================================================================
# STORAGE ACCOUNT ENCRYPTION (Optional)
# =============================================================================

# Optional: Customer-managed encryption key (requires Key Vault)
# Uncomment and configure if using customer-managed keys
# resource "azurerm_storage_account_customer_managed_key" "cmk" {
#   storage_account_id = azurerm_storage_account.sa.id
#   key_vault_id       = var.key_vault_id
#   key_name           = var.encryption_key_name
# }
