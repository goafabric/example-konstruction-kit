variable "hostname" {
  default = "kind.local"
}

locals {
  production_mode = !strcontains(var.hostname, ".local")
  cert_manager_issuer = "../modules/cert-manager/cert-manager-issuer/selfsigned" #local.production_mode == true ? "../modules/cert-manager/cert-manager-issuer/letsencrypt" : "../modules/cert-manager/cert-manager-issuer/selfsigned"
}
