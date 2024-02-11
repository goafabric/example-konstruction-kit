variable "hostname" {
  default = "kind"
}

variable "helm_timeout" {
  default = 60
}

variable "server_arch" {
  default = "" #should be set from environment, only required for native images on apple silicon m1
}

variable "helm_repository" {
  default = "../../helm/templates/core" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}

locals {
  authentication_enabled = var.hostname == "kind" ? "false" : "true"
}