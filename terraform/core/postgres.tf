resource "helm_release" "core-postgres-postgresql-ha-pgpool" {
  count = local.postgres_ha == "false" ? 1 : 0

  repository = var.helm_repository
  name       = "core-postgres-postgresql-ha-pgpool"
  chart      = "${var.helm_repository}/core/postgres"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.core_database_password.result
  }
}

resource "helm_release" "core-postgres-ha" {
  count = local.postgres_ha == "true" ? 1 : 0

  name       = "core-postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql-ha"
  version    = "14.0.0"
  namespace  = "core"

  set {
    name  = "postgresql.replicaCount"
    value = local.replica_count
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
  set {
    name  = "global.postgresql.username"
    value = "core"
  }
  set {
    name  = "global.postgresql.password"
    value = random_password.core_database_password.result
  }
  set {
    name  = "postgresql.postgresPassword"
    value = random_password.core_database_password.result
  }
}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {
  count = local.postgres_ha == "true" ? 1 : 0

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/instance=core-postgres -n core"
  }
}

resource "helm_release" "catalog-postgres-postgresql-ha-pgpool" {
  repository = var.helm_repository
  name       = "catalog-postgres-postgresql-ha-pgpool"
  chart      = "${var.helm_repository}/catalog/postgres"
  namespace  = "core"
  create_namespace = true
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.catalog_database_password.result
  }
}