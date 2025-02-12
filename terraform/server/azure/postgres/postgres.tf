resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "${var.resource_group_name}-postgres"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  administrator_login    = "pgadmin"
  administrator_password = random_password.postgres-password.result

  sku_name   = "GP_Standard_D2s_v3"
  storage_mb = 32768
  version    = "16"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled = false
}

resource "random_password" "postgres-password" {
  length  = 32
  special = false
}