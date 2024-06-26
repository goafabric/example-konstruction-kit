provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "random_password" "core_database_password" {
  length           = 32
  special          = false
}

resource "random_password" "s3_password" {
  length           = 32
  special          = false
}

resource "random_password" "service_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}