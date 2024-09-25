resource "kubernetes_service_account" "vault_read_account" {
  metadata {
    name = "vault-read-account"
  }
}