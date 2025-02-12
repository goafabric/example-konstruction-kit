data "azurerm_key_vault" "vault" {
  name                       = "${var.resource_group_name}-vault"
  resource_group_name        = var.resource_group_name
}

data "azurerm_key_vault_secret" "person-service-database-user" {
  name         = "person-service-database-user"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "person-service-database-password" {
  name         = "person-service-database-password"
  key_vault_id = data.azurerm_key_vault.vault.id
}

