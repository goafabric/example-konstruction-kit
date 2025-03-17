resource "helm_release" "core-postgres-postgresql-ha-pgpool" {

  repository = var.helm_repository
  name       = "core-postgres-postgresql-ha-pgpool"
  chart      = "../../helm/core/core/postgres"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.core_database_password.result
  }
}
