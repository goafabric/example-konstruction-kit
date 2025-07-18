variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 90
}

variable "helm_repository" {
  default = "../../helm/example/spring" #"../../helm/example/quarkus"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
}
