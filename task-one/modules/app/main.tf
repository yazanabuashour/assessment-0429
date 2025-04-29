resource "azurerm_public_ip" "lb" {
  name                = "${var.prefix}-lb-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-lb"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  name            = "${var.prefix}-lb-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "http" {
  name                = "${var.prefix}-lb-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "http" {
  name                         = "${var.prefix}-lb-rule"
  loadbalancer_id              = azurerm_lb.lb.id
  protocol                     = "Tcp"
  frontend_port                = 80
  backend_port                 = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids     = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                     = azurerm_lb_probe.http.id
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name = "${var.prefix}-vmss"
  resource_group_name = var.rg_name
  location = var.location
  sku = var.vm_size
  instances = var.instance_count
  admin_username = var.admin_username

  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name      = "ipcfg"
      primary   = true
      subnet_id = var.subnet_id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.pool.id,
      ]
    }
  }
}

