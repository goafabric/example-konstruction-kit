variable "hostname" {
  default = "kind"
}

locals {
  production_mode = var.hostname == "kind" ? "false" : "true"

  cert_manager_issuer = local.production_mode == "true" ? "./cert-manager-issuer/letsencrypt" : "./cert-manager-issuer/selfsigned"
  ingress_service_type = local.production_mode == "true" ? "LoadBalancer" : "NodePort"
}
