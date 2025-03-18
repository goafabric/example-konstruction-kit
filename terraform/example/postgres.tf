resource "helm_release" "postgresql" {

  name       = "postgresql"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  version    = "16.5.2"
  namespace  = "example"

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
    value = "main"
  }
  set_sensitive {
    name  = "global.postgresql.auth.username"
    value = "main"
  }
  set_sensitive {
    name  = "global.postgresql.auth.password"
    value = random_password.postgresql_password.result
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/name=postgresql -n example"
  }
}