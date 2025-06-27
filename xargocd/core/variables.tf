variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 90
}

variable "helm_repository" {
  default = "https://github.com/goafabric/example-konstruction-kit"
}

locals {
  oidc_enabled = strcontains(var.hostname, ".de")
}

# terraform taint helm_release.core-application
variable "multi_tenancy_tenants" {
  default = "0\\,5\\,8"
}
