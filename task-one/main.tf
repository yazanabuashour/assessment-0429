resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source          = "./modules/network"
  prefix          = var.prefix
  rg_name         = azurerm_resource_group.rg.name
  location        = var.location
  vnet_cidr       = var.vnet_cidr
  app_subnet_cidr = var.app_subnet_cidr
  db_subnet_cidr  = var.db_subnet_cidr
}

module "app" {
  source         = "./modules/app"
  prefix         = var.prefix
  rg_name        = azurerm_resource_group.rg.name
  location       = var.location
  subnet_id      = module.network.app_subnet_id
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  instance_count = var.instance_count
  vm_size        = var.vm_size
}

module "db" {
  source                  = "./modules/db"
  prefix                  = var.prefix
  rg_name                 = azurerm_resource_group.rg.name
  private_dns_zone_id     = module.network.postgres_private_dns_zone_id
  location                = var.location
  delegated_subnet_id     = module.network.db_subnet_id
  postgres_admin_username = var.postgres_admin_username
}

