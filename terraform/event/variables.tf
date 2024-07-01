variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 90
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

  messageBroker_replica_count = "2"  #this is not meant for production ! here we should at least have 3 instances
  dispatcher_profile = "nats" #kafka
}
