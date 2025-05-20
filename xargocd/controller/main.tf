provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  version = "2.29.0" #workaround for crashing kubernetes provider on route.yaml
}
