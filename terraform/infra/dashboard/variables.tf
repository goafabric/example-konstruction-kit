variable "hostname" {
  default = "kind.local"
}

locals {
  metrics_server_enabled = !strcontains(var.hostname, "azure")
}