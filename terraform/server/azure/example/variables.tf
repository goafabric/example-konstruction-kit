variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 90
}

variable "helm_repository" {
  default = "./helm" #"../../helm/example/quarkus"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  server_arch = data.external.server_arch_data.result["server_arch"]

  oidc_enabled = strcontains(var.hostname, ".de")
}

# terraform taint helm_release.person-service-application
# terraform taint 'helm_release.person-service-application["provisioning"]'
variable "multi_tenancy_tenants" {
  default = "0\\,5\\,8"
}

variable "tenant_id" {
  type        = string
}

variable "client_id" {
  type        = string
  default     = "cdf7e326-009d-4aec-bd82-1be8533126b6"
}

