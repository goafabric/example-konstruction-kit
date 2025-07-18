variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 30
}

variable "helm_repository" {
  default = "../../helm" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
}

