resource "helm_release" "postgresql" {

  name       = "postgresql"
  repository = "oci://registry-1.docker.io/cloudpirates"
  chart      = "postgres"
  version    = "0.13.4"
  namespace  = "example"

  set {
    name  = "extraEnv.TZ"
    value = "Europe/Berlin"
  }

  set {
    name  = "initdb.scripts.00_pg_statements\\.sql"
    value = "CREATE EXTENSION pg_stat_statements;"
  }

  set {
    name  = "startupProbe.enabled"
    value = false
  }

  set {
    name  = "auth.database"
    value = "main"
  }
  set_sensitive {
    name  = "auth.username"
    value = "main"
  }
  set_sensitive {
    name  = "auth.password"
    value = random_password.postgresql_password.result
  }


}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc data-postgresql-0 -n example"
  }
}