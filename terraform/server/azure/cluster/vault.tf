resource "azurerm_key_vault" "vault" {
  name                       = "${var.resource_group_name}-vault"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  enable_rbac_authorization  = "true"
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = 90
  sku_name                   = "standard"
}

resource "azurerm_role_assignment" "role-assignment-aks-identity" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_user_assigned_identity" "identity" {
  name                = "identity"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

data "azurerm_client_config" "current" {
}

resource "azurerm_role_assignment" "role-assignment-sa" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}


resource "azurerm_key_vault_secret" "person-service-database-user" {
  name         = "person-service-database-user"
  value        = "example"
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "person-service-database-password" {
  name         = "person-service-database-password"
  value        = random_password.person-service-database-password.result
  key_vault_id = azurerm_key_vault.vault.id
}

resource "random_password" "person-service-database-password" {
  length  = 32
  special = false
}

output "identity_id" {
  value = azurerm_user_assigned_identity.identity.client_id
  description = "The ID of the Azure User Assigned Identity"
}

resource "azurerm_federated_identity_credential" "federated-identity-example" {
  name                = "federated-identity-example"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
  subject             = "system:serviceaccount:example:vault-read-account"
}
