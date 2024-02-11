variable "hostname" {
  default = "kubernetes"
}

locals {
  cert_manager_issuer = var.hostname == "kind" ? "./cert-manager-issuer/selfsigned" : "./cert-manager-issuer/letsencrypt"
  ingress_service_type = var.hostname == "kind" ? "NodePort" : "LoadBalancer"
}
