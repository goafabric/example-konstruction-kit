variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 60
}

variable "helm_repository" {
  default = "../../helm/invoice"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  server_arch = data.external.server_arch_data.result["server_arch"]

  oidc_enabled = strcontains(var.hostname, ".de")
  cache_type = "dragonfly" #redis
  cache_replica_count = "1" # for production that should be at least 3
}
