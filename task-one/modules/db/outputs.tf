output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.pg.fqdn
}

output "postgres_admin_password" {
  value     = random_password.pg.result
  sensitive = true
}

