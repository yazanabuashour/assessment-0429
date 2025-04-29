output "app_subnet_id" {
  value = azurerm_subnet.app.id
}
output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

output "postgres_private_dns_zone_id" {
  description = "ID of the Private DNS Zone for PostgreSQL"
  value       = azurerm_private_dns_zone.postgres.id
}
