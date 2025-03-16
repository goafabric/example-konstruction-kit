resource "helm_release" "person-service-postgres" {
  repository = var.helm_repository
  name       = "person-service-postgres-postgresql-ha-pgpool"
  chart      = "${var.helm_repository}/person-service/postgres"
  namespace  = "example"
  create_namespace = false
  timeout = var.helm_timeout

  set {
    name  = "database.password"
    value = random_password.postgres_password.result
  }
}

/*
resource "helm_release" "person-service-postgres" {
  name       = "person-service-postgres-postgresql-ha-pgpool"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.36"
  namespace  = "example"
  timeout    = "50"

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
    value = random_password.postgres_password.result
  }

}


# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/name=postgresql -n example"
  }
}
*/