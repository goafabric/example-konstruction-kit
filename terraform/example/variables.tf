variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 90
}

variable "helm_repository" {
  default = "../../helm/example/spring" #"../../helm/example/quarkus"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  production_mode = !strcontains(var.hostname, ".local")
  server_arch = data.external.server_arch_data.result["server_arch"]
  oidc_enabled = true #local.production_mode

  replica_count = local.production_mode ? "2" : "1"
  postgres_ha = "false"
}
