variable "hostname" {
  default = "kind"
}

variable "helm_timeout" {
  default = 200
}

variable "infra_repository" {
  default = "../../../../helm/templates/infra" #"https://goafabric.github.io/example-konstruction-kit/helm/charts/example/infra"
}

locals {
  production_mode = var.hostname == "kind" ? "false" : "true"
  base_url = local.production_mode == "true" ? "https://${var.hostname}:443" : "https://${var.hostname}:32443"
}