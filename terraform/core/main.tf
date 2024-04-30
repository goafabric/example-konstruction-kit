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

resource "random_password" "catalog_database_password" {
  length           = 32
  special          = false
}

resource "random_password" "s3_password" {
  length           = 32
  special          = false
}