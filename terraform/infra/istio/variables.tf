variable "hostname" {
  default = "kind.local"
}

locals {
  istio_mode = "ambient" # sidecar
}