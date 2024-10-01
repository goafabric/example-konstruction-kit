## apps

resource "terraform_data" "create_bank_vault_example" {
  depends_on = [vault_mount.databases]
  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f ./example-apps/bank-vault-example.yaml -n example"
  }
}

resource "terraform_data" "destroy_bank_vault_example" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ./example-apps/bank-vault-example.yaml -n example"
  }
}

# resource "terraform_data" "create_vault_example" {
#   depends_on = [vault_mount.databases]
#   provisioner "local-exec" {
#     when    = create
#     command = "kubectl apply -f ./example-apps/vault-injector-example.yaml -n example"
#   }
# }
#
# resource "terraform_data" "destroy_vault_example" {
#   provisioner "local-exec" {
#     when    = destroy
#     command = "kubectl delete -f ./example-apps/vault-injector-example.yaml -n example"
#   }
# }


resource "random_password" "database_password" {
  length           = 32
  special          = false
}


resource "vault_kv_secret_v2" "vault-example-service-postgres" {
  depends_on = [vault_mount.databases]

  mount                      = "databases"
  name                       = "example-service-postgres"
  cas                        = 1
  delete_all_versions        = true

  data_json = jsonencode({
    POSTGRES_USER = "example-service"
    POSTGRES_PASSWORD = random_password.database_password.result
    "spring.datasource.username" = "example-service"
    "spring.datasource.password" = random_password.database_password.result
  })
}



