variable "hostname" {
  default = "kind"
}

variable "helm_timeout" {
  default = 60
}

variable "server_arch" {
  default = "" #should be set from environment, only required for native images on apple silicon m1
}

variable "helm_repository" {
  default = "https://github.com/goafabric/example-konstruction-kit"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  server_arch = data.external.server_arch_data.result["server_arch"]
}
