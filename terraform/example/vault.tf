resource "terraform_data" "vault-create-person-service-postgres" {
  provisioner "local-exec" {
    when = create
    command = "kubectl exec vault-0 -n vault -- sh -c 'U=person-service;P=${local.password};vault kv put databases/person-service-postgres POSTGRES_USER=$U POSTGRES_PASSWORD=$P spring.datasource.username=$U spring.datasource.password=$P'"
  }
}

resource "terraform_data" "vault-destroy-person-service-postgres" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl exec vault-0 -n vault -- sh -c 'vault kv delete databases/person-service-postgres'"
  }
}

locals {
  password = "$(cat /proc/sys/kernel/random/uuid | tr -d '-' | sha256sum | base64 | head -c 32)"
}