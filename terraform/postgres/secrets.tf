resource "random_password" "database_password" {
  length           = 32
  special          = false
}