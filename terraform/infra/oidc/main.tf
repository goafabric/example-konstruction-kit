terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}



provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "keycloak" {
  client_id     = "admin-cli"
  username      = "admin"
  password      = random_password.admin_password.result
  url           = "https://${var.hostname}/oidc"
  initial_login = false
}

resource "random_password" "admin_password" {
  length           = 32
  special          = false
}

resource "random_password" "database_password" {
  length           = 32
  special          = false
}