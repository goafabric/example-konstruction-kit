variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 120
}

variable "helm_repository" {
  default = "../../helm/event"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  server_arch = data.external.server_arch_data.result["server_arch"]

  production_mode = !strcontains(var.hostname, ".local")
  oidc_enabled = local.production_mode

  nats_replica_count = "2"
  kafka_replica_count = "1" #for production this should be 3
  dispatcher_profile = "kafka" #nats
}
