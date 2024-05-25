resource "helm_release" "invoice-process-application" {
  repository = var.helm_repository
  name       = "invoice-process-application"
  chart      = "${var.helm_repository}/invoice-process/application"
  namespace  = "invoice"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "replicaCount"
    value = local.replica_count
  }

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
  set {
    name = "service.password"
    value = random_password.service_password.result
  }
}