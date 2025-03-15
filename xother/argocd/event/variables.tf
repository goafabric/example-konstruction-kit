variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 120
}

variable "helm_repository" {
  default = "https://github.com/goafabric/example-konstruction-kit"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  server_arch = data.external.server_arch_data.result["server_arch"]

  oidc_enabled = strcontains(var.hostname, ".de")

  kafka_replica_count = "1" #for production this should be 3
}
