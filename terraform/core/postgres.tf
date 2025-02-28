resource "helm_release" "core-postgres-postgresql-ha-pgpool" {
  count = local.postgres_ha == false ? 1 : 0

  repository = var.helm_repository
  name       = "core-postgres-postgresql-ha-pgpool"
  chart      = "${var.helm_repository}/core/postgres"
  namespace  = "core"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.core_database_password.result
  }
}

/*
resource "helm_release" "core-postgres-ha" {
  count = local.postgres_ha == true ? 1 : 0

  name       = "core-postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql-ha"
  version    = "14.2.27"
  namespace  = "core"

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
    value = "core"
  }
  set_sensitive {
    name  = "global.postgresql.username"
    value = "core"
  }
  set_sensitive {
    name  = "global.postgresql.password"
    value = random_password.core_database_password.result
  }
  set_sensitive {
    name  = "postgresql.password"
    value = random_password.core_database_password.result
  }
  set {
    name  = "pgpool.reservedConnections"
    value = "0" //https://github.com/bitnami/charts/issues/4219
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {
  count = local.postgres_ha == true ? 1 : 0

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/name=postgresql -n core"
  }
}

 */