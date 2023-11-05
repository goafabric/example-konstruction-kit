provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

variable "hostname" {}

variable "example_repository" {
  default = "https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}