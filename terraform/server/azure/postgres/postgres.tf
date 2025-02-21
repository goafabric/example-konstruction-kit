resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "${var.resource_group_name}-postgres"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  administrator_login    = data.azurerm_key_vault_secret.person-service-database-user.value
  administrator_password = data.azurerm_key_vault_secret.person-service-database-password.value

  sku_name   = "GP_Standard_D2s_v3"
  storage_mb = 32768
  version    = "16"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled = true
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}