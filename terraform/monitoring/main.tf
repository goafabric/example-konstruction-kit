provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

variable "hostname" {}

variable "infra_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/infra"
}