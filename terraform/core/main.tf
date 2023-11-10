provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

variable "hostname" {}

variable "server_arch" { default = "-arm64v8" }

variable "example_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}