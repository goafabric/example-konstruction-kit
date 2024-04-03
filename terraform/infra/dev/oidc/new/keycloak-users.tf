resource "terraform_data" "keycloak_users" {
  depends_on = [helm_release.keycloak]
  provisioner "local-exec" {
    when    = create
    command = var.hostname == "kind" ? "./scripts/create-users https://${var.hostname}:32443" : "./scripts/create-users https://${var.hostname}:443"
  }
}
