variable "hostname" {
  default = "kind.local"
}

variable "helm_timeout" {
  default = 60
}

variable "image_registry" {
  default = "goafabric"
}

variable "image_registry_user" {
  default = "goafabric"
}

variable "image_registry_password" {
  default = "goafabric"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  server_arch = data.external.server_arch_data.result["server_arch"]
}