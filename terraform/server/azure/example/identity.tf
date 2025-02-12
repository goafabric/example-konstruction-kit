data "azurerm_user_assigned_identity" "key_vault_identity" {
  name                = "identity"
  resource_group_name = var.resource_group_name
}
