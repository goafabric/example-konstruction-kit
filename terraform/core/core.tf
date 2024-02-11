resource "helm_release" "core-postgres" {
  repository = var.helm_repository
  name       = "core-postgres"
  chart      = "${var.helm_repository}/02_core/01_postgres"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}

resource "helm_release" "core-application" {
  repository = var.helm_repository
  name       = "core-application"
  chart      = "${var.helm_repository}/02_core/02_application"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "security.authentication.enabled"
    value = var.hostname == "kind" ? "false" : "true"
  }
  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
  set {
    name  = "s3.password"
    value = random_password.s3_password.result
  }
}

resource "helm_release" "s3-minio" {
  repository = var.helm_repository
  name       = "s3-minio"
  chart      = "${var.helm_repository}/01_minio/application"
  version    = "1.1.2"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "ingress.hosts"
    value = var.hostname
  }
  set {
    name  = "s3.password"
    value = random_password.s3_password.result
  }
}