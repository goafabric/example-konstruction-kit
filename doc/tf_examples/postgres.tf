resource "helm_release" "person-service-postgres" {
  count = local.postgres_ha == "false" ? 1 : 0

  name       = "person-service-postgres-postgresql-ha-pgpool"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.1.4"
  namespace  = "example"

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
    name  = "global.postgresql.auth.database"
    value = "person"
  }
  set {
    name  = "global.postgresql.auth.username"
    value = "person-service"
  }
  set {
    name  = "global.postgresql.auth.password"
    value = random_password.database_password.result
  }

  set {
    name  = "primary.readinessProbe.initialDelaySeconds"
    value = "2"
  }
  set {
    name  = "primary.readinessProbe.periodSeconds"
    value = "2"
  }
}

resource "helm_release" "person-service-postgres-ha" {
  count = local.postgres_ha == "true" ? 1 : 0

  name       = "person-service-postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql-ha"
  version    = "14.0.0"
  namespace  = "example"

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
    name  = "postgresql.postgresPassword"
    value = random_password.database_password.result
  }
  set {
    name  = "postgresql.readinessProbe.initialDelaySeconds"
    value = "2"
  }
  set {
    name  = "postgresql.readinessProbe.periodSeconds"
    value = "2"
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {
  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete ns example"
    #command = "kubectl delete pvc -l app.kubernetes.io/name=postgresql -n example"
  }
}