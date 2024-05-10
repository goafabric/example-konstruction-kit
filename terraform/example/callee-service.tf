resource "helm_release" "callee-service-application" {
  repository = var.helm_repository
  name       = "callee-service-application"
  chart      = "${var.helm_repository}/callee-service/application"
  namespace  = "example"
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
#   set {
#     name  = "image.arch"
#     value = strcontains(var.helm_repository, "spring") ? "-native${local.server_arch}" : local.server_arch
#   }
  set {
    name = "authentication.enabled"
    value = local.authentication_enabled
  }
  set {
    name = "service.password"
    value = random_password.service_password.result
  }
}