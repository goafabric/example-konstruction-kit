resource "terraform_data" "keycloak_users" {
  depends_on = [helm_release.keycloak]
  provisioner "local-exec" {
    when    = create
    command =  "./scripts/create-users https://${var.hostname}"
  }
}
