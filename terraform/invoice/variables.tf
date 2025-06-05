variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 60
}

variable "helm_repository" {
  default = "../../helm/invoice"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
  cache_type = "dragonfly" #redis
}
