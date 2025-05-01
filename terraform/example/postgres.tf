resource "helm_release" "postgresql" {

  name       = "postgresql"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  version    = "16.5.2"
  namespace  = "example"

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
  set {
    name  = "gloabl.networkPolicy.enabled"
    value = false
  }
  set {
    name  = "primary.networkPolicy.enabled"
    value = false
  }

}

# manually remove the pvc to avoid password problems
resource "terraform_data" "remove_postgres_pvc" {

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete pvc -l app.kubernetes.io/name=postgresql -n example"
  }
}