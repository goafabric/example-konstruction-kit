variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 90
}

variable "helm_repository" {
  default = "../../helm/core" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
}

# terraform taint helm_release.core-application
variable "multi_tenancy_tenants" {
  default = "42"
}
