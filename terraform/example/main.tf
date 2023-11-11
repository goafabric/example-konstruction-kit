provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

variable "helm_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring" # "../../helm/templates/example/spring"
}