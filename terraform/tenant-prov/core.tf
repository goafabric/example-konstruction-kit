resource "helm_release" "core-provisioning" {
  repository = var.helm_repository
  name       = "core-provisioning"
  chart      = "${var.helm_repository}/core/core/provisioning"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  values = [
    file("../../helm/values.yaml")
  ]

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  
}

