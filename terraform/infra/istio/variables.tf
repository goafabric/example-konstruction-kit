variable "hostname" {
  default = "kind.local"
}

locals {
  microk8s_mode = strcontains(var.hostname, ".de")
  istio_mode = "ambient" # sidecar
}