resource "helm_release" "invoice-process-application" {
  depends_on = [helm_release.redis]
  repository = var.helm_repository
  name       = "invoice-process-application"
  chart      = "${var.helm_repository}/invoice-process/application"
  namespace  = "invoice"
  create_namespace = false
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
    name = "service.password"
    value = random_password.service_password.result
  }
  set {
    name  = "s3.password"
    value = "minioadmin" #random_password.s3_password.result
  }


  set {
    name = "oidc.enabled"
    value = local.oidc_enabled
  }
}
