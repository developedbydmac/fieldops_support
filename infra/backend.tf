terraform {
  backend "azurerm" {
    # TODO: Update these values after creating the backend storage account
    resource_group_name  = "rg-fieldops-tfstate"
    storage_account_name = "safieldopstfstate"
    container_name       = "tfstate"
    key                  = "fieldops-support-ai-${terraform.workspace}.tfstate"
  }
}
