variable "hostname" {
  default = "kind.local"
}

locals {
  microk8s_mode = strcontains(var.hostname, "megasrv.de")
}