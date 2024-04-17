resource "helm_release" "person-service-application" {
  repository = var.helm_repository
  name       = "person-service-application"
  chart      = "${var.helm_repository}/person-service/application"
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
  set {
    name  = "image.arch"
    value = "-native${local.server_arch}"
  }
  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}


