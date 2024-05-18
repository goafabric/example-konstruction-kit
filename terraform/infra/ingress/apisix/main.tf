provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "cert-manager" {
  source = "../modules/cert-manager"
  hostname = var.hostname
}