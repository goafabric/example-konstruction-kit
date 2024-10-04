resource "helm_release" "person-service-postgres" {
  count = local.postgres_ha == false ? 1 : 0

  repository = var.helm_repository
  name       = "person-service-postgres-postgresql-ha-pgpool"
  chart      = "${var.helm_repository}/person-service/postgres"
  namespace  = "example"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.database_password.result
  }
}

resource "helm_release" "person-service-postgres-ha" {
  count = local.postgres_ha == true ? 1 : 0

  name       = "person-service-postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql-ha"
  version    = "14.2.27"
  namespace  = "example"

  set {
    name  = "postgresql.replicaCount"
    value = "2"
  }
  set {
    name  = "persistence.size"
    value = "2Gi"
  }

  set {
    name  = "postgresql.extraEnvVars[0].name"
    value = "TZ"
  }
  set {
    name  = "postgresql.extraEnvVars[0].value"
    value = "Europe/Berlin"
  }
  set {
    name  = "postgresql.initdbScripts.00_pg_statements\\.sql"
    value = "CREATE EXTENSION pg_stat_statements;"
  }
  set {
    name  = "global.postgresql.database"
    value = "person"
  }
  set {
    name  = "global.postgresql.username"
    value = "person-service"
  }
  set {
    name  = "global.postgresql.password"
    value = random_password.database_password.result
  }
  set {
    name  = "postgresql.password"
    value = random_password.database_password.result
  }
  set {
    name  = "pgpool.reservedConnections"
    value = "0" //https://github.com/bitnami/charts/issues/4219
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/name=postgresql -n example"
  }
}