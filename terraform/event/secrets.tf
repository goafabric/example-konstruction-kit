resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}