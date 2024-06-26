variable "hostname" {
  default = "kind.local"
}

locals {
  production_mode = !strcontains(var.hostname, ".local")

  ingress_service_type = local.production_mode == true ? "LoadBalancer" : "NodePort"
}
