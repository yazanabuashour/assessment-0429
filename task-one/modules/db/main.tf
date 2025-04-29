resource "random_password" "pg" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "pg" {
  name                       = "${var.prefix}-pg"
  resource_group_name        = var.rg_name
  location                   = var.location
  version                    = "16"
  sku_name                   = "B_Standard_B1ms"
  delegated_subnet_id        = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id
  storage_mb                 = 32768
  backup_retention_days      = 7
  administrator_login        = var.postgres_admin_username
  administrator_password     = random_password.pg.result
  public_network_access_enabled = false
}

