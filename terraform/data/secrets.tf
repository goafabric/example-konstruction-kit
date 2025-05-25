resource "random_password" "postgresql_password" {
  length           = 32
  special          = false
}

resource "random_password" "s3_password" {
  length           = 32
  special          = false
}

resource "random_password" "oidc_session_secret" {
  length           = 32
  special          = false
}




