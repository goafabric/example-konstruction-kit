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

# terraform taint helm_release.person-service-application
# terraform taint 'helm_release.person-service-application["provisioning"]'
variable "multi_tenancy_tenants" {
  default = "0\\,5\\,8"
}
