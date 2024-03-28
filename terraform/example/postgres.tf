resource "helm_release" "person-service-postgres-postgresql-ha-pgpool" {
  repository = var.helm_repository
  name       = "person-service-postgres-postgresql-ha-pgpool"
  chart      = "${var.helm_repository}/person-service/postgres"
#  version    = "1.1.2"
  namespace  = "example"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}