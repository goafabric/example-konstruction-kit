resource "random_password" "messageBroker_password" {
  length           = 32
  special          = false
}