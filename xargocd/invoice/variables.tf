variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 60
}

variable "helm_repository" {
  default = "https://github.com/goafabric/example-konstruction-kit"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
  cache_type = "dragonfly" #redis
}
