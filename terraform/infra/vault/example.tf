# secrets

resource "terraform_data" "vault-create-example-service-postgres" {
  depends_on = [terraform_data.vault_read_policy]
  provisioner "local-exec" {
    when = create
    command = <<EOT
kubectl exec vault-0 -n vault -- sh -c 'U=person-service;P=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | sha256sum | base64 | head -c 32);
  vault kv put databases/example-service-postgres POSTGRES_USER=$U POSTGRES_PASSWORD=$P spring.datasource.username=$U spring.datasource.password=$P;'
EOT
  }
}

# resource "terraform_data" "vault-destroy-example-service-postgres" {
#   provisioner "local-exec" {
#     when = destroy
#     command = "kubectl exec vault-0 -n vault -- sh -c 'vault kv delete databases/example-service-postgres'"
#   }
# }


# resource "vault_kv_secret_v2" "vault-example-service-postgres" {
#   depends_on = [vault_mount.databases]
#
#   mount                      = vault_mount.kvv2.path
#   name                       = "databases/example-service-postgres"
#   cas                        = 1
#   delete_all_versions        = true
#
#
#   data_json = jsonencode({
#     POSTGRES_USER = "example-service"
#     POSTGRES_PASSWORD = "sUp3rS3cUr3Passw0rd"
#     "spring.datasource.username" = "example-service"
#     "spring.datasource.password" = "sUp3rS3cUr3Passw0rd"
#   })
# }

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

