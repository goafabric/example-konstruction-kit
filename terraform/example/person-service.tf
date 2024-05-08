resource "helm_release" "person-service-application" {
  repository = var.helm_repository
  name       = "person-service-application"
  chart      = "${var.helm_repository}/person-service/application"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "replicaCount"
    value = "1"
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
    name  = "database.password"
    value = random_password.database_password.result
  }
  set {
    name = "serviceUser.password"
    value = random_password.service_password.result
  }
  set {
    name = "authentication.enabled"
    value = local.authentication_enabled
  }
}


