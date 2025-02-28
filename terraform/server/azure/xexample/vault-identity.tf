provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

data "azurerm_user_assigned_identity" "key_vault_identity" {
  name                = "identity"
  resource_group_name = var.resource_group_name
}
