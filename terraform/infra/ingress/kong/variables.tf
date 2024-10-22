variable "hostname" {
  default = "kind.local"
}

locals {
  ingress_service_type = !strcontains(var.hostname, "kind.local") == true ? "LoadBalancer" : "NodePort"
}

output "hostname" {
  value = var.hostname
}