variable "hostname" {
  default = "kind"
}

variable "helm_timeout" {
  default = 60
}

variable "helm_repository" {
  default = "../../helm/templates/core" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/spring"
}

data "external" "server_arch_data" {
  program = ["sh", "-c", "if kubectl version --output=json | grep -q 'linux/arm64'; then echo '{\"server_arch\":\"-arm64v8\"}'; else echo '{\"server_arch\":\"\"}'; fi"]
}

locals {
  authentication_enabled = var.hostname == "kind" ? "false" : "true"
  server_arch = data.external.server_arch_data.result["server_arch"]
}

