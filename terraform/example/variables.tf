variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 60
}

variable "helm_repository" {
  default = "../../helm/example/quarkus" #"../../helm/example/quarkus"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
}
