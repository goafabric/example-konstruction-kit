variable "hostname" {
  default = "kind.local"
}

locals {
  production_mode = !strcontains(var.hostname, ".local")
}