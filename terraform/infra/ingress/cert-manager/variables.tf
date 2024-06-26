variable "hostname" {
  default = "kind.local"
}

locals {
  production_mode = !strcontains(var.hostname, ".local")
  cert_manager_issuer = "./cert-manager-issuer/selfsigned" #local.production_mode == true ? "./cert-manager-issuer/letsencrypt" : "./cert-manager-issuer/selfsigned"
}
