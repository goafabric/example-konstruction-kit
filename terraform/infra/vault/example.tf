## secret
resource "vault_kv_secret" "example-service-postgres" {
  depends_on = [helm_release.vault]
  path = "secret/data/database/example-service-postgres"

  data_json = jsonencode({
    data = {
      POSTGRES_USER = "example-service"
      POSTGRES_PASSWORD = "sUp3rS3cUr3Passw0rd"
      "spring.datasource.username" = "example-service"
      "spring.datasource.password" = "sUp3rS3cUr3Passw0rd"
    }
  })
}

## apps

resource "terraform_data" "create_vault_example" {
  depends_on = [helm_release.vault]
  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f ./example-apps/vault-injector-example.yaml -n example"
  }
}

resource "terraform_data" "destroy_vault_example" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ./example-apps/vault-injector-example.yaml -n example"
  }
}


resource "terraform_data" "create_bank_vault_example" {
  depends_on = [helm_release.vault]
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

# resource "terraform_data" "create_operator_example" {
#   depends_on = [terraform_data.create_stack]
#   provisioner "local-exec" {
#     when    = create
#     command = "kubectl apply -f ./example-apps/vault-operator-example.yaml -n example"
#   }
# }
#
# resource "terraform_data" "destroy_operator_example" {
#   provisioner "local-exec" {
#     when    = destroy
#     command = "kubectl delete -f ./example-apps/vault-operator-example.yaml -n example"
#   }
# }