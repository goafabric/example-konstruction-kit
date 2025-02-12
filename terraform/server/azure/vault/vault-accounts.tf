resource "kubernetes_namespace" "example" {
  metadata {
    name = "example"
  }
}

resource "kubernetes_service_account" "example-vault-read-account" {
  metadata {
    name      = "vault-read-account"
    namespace = "example"
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.identity.client_id
    }
  }
}

resource "azurerm_federated_identity_credential" "federated-identity-example" {
  name                = "federated-identity-example"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.k8s.oidc_issuer_url
  subject             = "system:serviceaccount:example:vault-read-account"
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
