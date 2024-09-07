variable "hostname" {
  default = "kind.local"
}

locals {
  cert_manager_issuer = "./cert-manager-issuer/selfsigned"
}
