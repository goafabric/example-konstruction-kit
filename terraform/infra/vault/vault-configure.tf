provider "vault" {
  address = "http://localhost:8200"
  token   = "root"

}

resource "kubernetes_service_account" "vault_read_account" {
  metadata {
    name = "vault-read-account"
  }
}

resource "vault_kv_secret" "my_secret" {
  path = "secret/data/application/my-service-application"

  data_json = jsonencode({
    data = {
      username = "myuser"
      password = "sUp3rS3cUr3P@ssw0rd"
    }
  })
}

