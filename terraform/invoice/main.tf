provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "random_password" "redis_password" {
  length           = 32
  special          = false
}

resource "random_password" "service_password" {
  length           = 32
  special          = false
}