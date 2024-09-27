provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "random_password" "database_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}

resource "terraform_data" "vault-person-service-postgres" {
  provisioner "local-exec" {
    command = <<EOT
kubectl exec -it vault-0 -n vault -- sh -c 'U=person-service;P=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | sha256sum | base64 | head -c 32);
  vault kv put databases/person-service-postgres POSTGRES_USER=$U POSTGRES_PASSWORD=$P spring.datasource.username=$U spring.datasource.password=$P;'
EOT
  }
}