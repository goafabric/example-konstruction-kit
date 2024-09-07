variable "hostname" {
  default = "kind.local"
}

locals {
  microk8s_mode = false #!strcontains(var.hostname, "kind.local")
}