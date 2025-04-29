# Task One

This folder contains the Terraform required to deploy a basic 3-tier application in Azure

## Improvements

This is not production ready and only a skeleton.

- **VMSS Instance Sizing:** Appropriate VM instance SKUs.
- **High Availability:** Multi-AZ redundancy for the VMSS and PostgreSQL database.
- **NAT Gateway:** Implement a NAT Gateway so instance can access internet.
- **VMSS Autoscaling:**
- **Secrets Management:**
- **CI/CD Pipeline:** Run Terraform from a CI/CD pipeline.
- **Remote State Backend:** Store Terraform state in a remote encryped backend like blob storage or Hashicorp cloud
- **Terraform Testing:**
- **Variable Management:** Use a `terraform.tfvars` file or environment variables
- **Network Security:** Implement stricter Network Security Group rules.

## Prerequisites

1.  **Azure Subscription:**
2.  **Azure Service Principal:** Create an Azure Service Principal with the `Contributor` role.
3.  **Environment Variables:** Configure the following environment variables.
    ```bash
    export ARM_CLIENT_ID="<APPID_VALUE>"
    export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
    export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
    export ARM_TENANT_ID="<TENANT_VALUE>"
    ```
4.  **SSH Key Pair:** Generate an SSH key pair or use existing

## Deployment Steps

1.  **Clone the Repository and cd into task-one:**

2.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

3.  **Format Code:**

    ```bash
    terraform fmt
    ```

4.  **Validate Configuration:**

    ```bash
    terraform validate
    ```

5.  **Plan Deployment:** Preview the changes Terraform will make to your Azure environment.

    ```bash
    terraform plan
    ```

6.  **Apply Configuration:** Create the resources in Azure.
    ```bash
    terraform apply
    ```

## Terraform Plan Output

````
The following output is expected when running `terraform plan`. You will be prompted to enter your SSH public key.

```terraform
var.ssh_public_key
  SSH public key

  Enter a value: <PASTE YOUR SSH PUBLIC KEY HERE>


Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "eastus2"
      + name     = "rg-assessment-3tier"
      + tags     = {
          + "env"     = "assessment"
          + "project" = "3tier"
        }
    }

  # module.app.azurerm_lb.lb will be created
  + resource "azurerm_lb" "lb" {
      + id                   = (known after apply)
      + location             = "eastus2"
      + name                 = "assessment-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "rg-assessment-3tier"
      + sku                  = "Standard"
      + sku_tier             = "Regional"

      + frontend_ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + id                                                 = (known after apply)
          + inbound_nat_rules                                  = (known after apply)
          + load_balancer_rules                                = (known after apply)
          + name                                               = "public"
          + outbound_rules                                     = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = (known after apply)
          + private_ip_address_version                         = (known after apply)
          + public_ip_address_id                               = (known after apply)
          + public_ip_prefix_id                                = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # module.app.azurerm_lb_backend_address_pool.pool will be created
  + resource "azurerm_lb_backend_address_pool" "pool" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + inbound_nat_rules         = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "assessment-lb-pool"
      + outbound_rules            = (known after apply)
    }

  # module.app.azurerm_lb_probe.http will be created
  + resource "azurerm_lb_probe" "http" {
      + id                  = (known after apply)
      + interval_in_seconds = 5
      + load_balancer_rules = (known after apply)
      + loadbalancer_id     = (known after apply)
      + name                = "assessment-lb-probe"
      + number_of_probes    = 2
      + port                = 80
      + probe_threshold     = 1
      + protocol            = "Http"
      + request_path        = "/"
    }

  # module.app.azurerm_lb_rule.http will be created
  + resource "azurerm_lb_rule" "http" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 80
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "public"
      + frontend_port                  = 80
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "assessment-lb-rule"
      + probe_id                       = (known after apply)
      + protocol                       = "Tcp"
    }

  # module.app.azurerm_linux_virtual_machine_scale_set.vmss will be created
  + resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
      + admin_username                                    = "adminuser"
      + computer_name_prefix                              = (known after apply)
      + disable_password_authentication                   = true
      + do_not_run_extensions_on_overprovisioned_machines = false
      + extension_operations_enabled                      = (known after apply)
      + extensions_time_budget                            = "PT1H30M"
      + id                                                = (known after apply)
      + instances                                         = 1
      + location                                          = "eastus2"
      + max_bid_price                                     = -1
      + name                                              = "assessment-vmss"
      + overprovision                                     = true
      + platform_fault_domain_count                       = (known after apply)
      + priority                                          = "Regular"
      + provision_vm_agent                                = true
      + resource_group_name                               = "rg-assessment-3tier"
      + scale_in_policy                                   = (known after apply)
      + single_placement_group                            = true
      + sku                                               = "Standard_A1_v2"
      + unique_id                                         = (known after apply)
      + upgrade_mode                                      = "Manual"
      + zone_balance                                      = false

      + admin_ssh_key {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + automatic_instance_repair (known after apply)

      + extension (known after apply)

      + gallery_application (known after apply)

      + gallery_applications (known after apply)

      + network_interface {
          + enable_accelerated_networking = false
          + enable_ip_forwarding          = false
          + name                          = "nic"
          + primary                       = true

          + ip_configuration {
              + load_balancer_backend_address_pool_ids = (known after apply)
              + name                                   = "ipcfg"
              + primary                                = true
              + subnet_id                              = (known after apply)
              + version                                = "IPv4"
            }
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + scale_in (known after apply)

      + source_image_reference {
          + offer     = "0001-com-ubuntu-server-jammy"
          + publisher = "Canonical"
          + sku       = "22_04-lts"
          + version   = "latest"
        }

      + spot_restore (known after apply)

      + terminate_notification (known after apply)

      + termination_notification (known after apply)
    }

  # module.app.azurerm_public_ip.lb will be created
  + resource "azurerm_public_ip" "lb" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "eastus2"
      + name                    = "assessment-lb-pip"
      + resource_group_name     = "rg-assessment-3tier"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

  # module.db.azurerm_postgresql_flexible_server.pg will be created
  + resource "azurerm_postgresql_flexible_server" "pg" {
      + administrator_login           = "postgresadminun"
      + administrator_password        = (sensitive value)
      + auto_grow_enabled             = false
      + backup_retention_days         = 7
      + delegated_subnet_id           = (known after apply)
      + fqdn                          = (known after apply)
      + geo_redundant_backup_enabled  = false
      + id                            = (known after apply)
      + location                      = "eastus2"
      + name                          = "assessment-pg"
      + private_dns_zone_id           = (known after apply)
      + public_network_access_enabled = false
      + resource_group_name           = "rg-assessment-3tier"
      + sku_name                      = "B_Standard_B1ms"
      + storage_mb                    = 32768
      + storage_tier                  = (known after apply)
      + version                       = "16"

      + authentication (known after apply)
    }

  # module.db.random_password.pg will be created
  + resource "random_password" "pg" {
      + bcrypt_hash      = (sensitive value)
      + id               = (known after apply)
      + length           = 16
      + lower            = true
      + min_lower        = 0
      + min_numeric      = 0
      + min_special      = 0
      + min_upper        = 0
      + number           = true
      + numeric          = true
      + override_special = "!#$%&*()-_=+[]{}<>:?"
      + result           = (sensitive value)
      + special          = true
      + upper            = true
    }

  # module.network.azurerm_network_security_group.app_nsg will be created
  + resource "azurerm_network_security_group" "app_nsg" {
      + id                  = (known after apply)
      + location            = "eastus2"
      + name                = "assessment-app-nsg"
      + resource_group_name = "rg-assessment-3tier"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "AllowSshInbound"
              + priority                                   = 110
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "Internet"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "80"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "AllowLoadBalancerInbound"
              + priority                                   = 100
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "AzureLoadBalancer"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
    }

  # module.network.azurerm_network_security_group.db_nsg will be created
  + resource "azurerm_network_security_group" "db_nsg" {
      + id                  = (known after apply)
      + location            = "eastus2"
      + name                = "assessment-db-nsg"
      + resource_group_name = "rg-assessment-3tier"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "5432"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "AllowPostgresInboundFromApp"
              + priority                                   = 100
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "10.0.2.0/24" # App Subnet
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          + {
              + access                                     = "Deny"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "DenyAllOtherInbound"
              + priority                                   = 4096
              + protocol                                   = "*"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
    }

  # module.network.azurerm_private_dns_zone.postgres will be created
  + resource "azurerm_private_dns_zone" "postgres" {
      + id                                                    = (known after apply)
      + max_number_of_record_sets                             = (known after apply)
      + max_number_of_virtual_network_links                   = (known after apply)
      + max_number_of_virtual_network_links_with_registration = (known after apply)
      + name                                                  = "privatelink.postgres.database.azure.com"
      + number_of_record_sets                                 = (known after apply)
      + resource_group_name                                   = "rg-assessment-3tier"

      + soa_record (known after apply)
    }

  # module.network.azurerm_private_dns_zone_virtual_network_link.postgres_vnet_link will be created
  + resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet_link" {
      + id                    = (known after apply)
      + name                  = "assessment-pg-dns-link"
      + private_dns_zone_name = "privatelink.postgres.database.azure.com"
      + registration_enabled  = false
      + resource_group_name   = "rg-assessment-3tier"
      + virtual_network_id    = (known after apply)
    }

  # module.network.azurerm_subnet.app will be created
  + resource "azurerm_subnet" "app" {
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + default_outbound_access_enabled                = true
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = "app-subnet"
      + private_endpoint_network_policies              = (known after apply)
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = "rg-assessment-3tier"
      + virtual_network_name                           = "assessment-vnet"
    }

  # module.network.azurerm_subnet.db will be created
  + resource "azurerm_subnet" "db" {
      + address_prefixes                               = [
          + "10.0.3.0/24",
        ]
      + default_outbound_access_enabled                = true
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = "db-subnet"
      + private_endpoint_network_policies              = (known after apply)
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = "rg-assessment-3tier"
      + virtual_network_name                           = "assessment-vnet"

      + delegation {
          + name = "db-delegate"

          + service_delegation {
              + actions = [
                  + "Microsoft.Network/virtualNetworks/subnets/join/action",
                ]
              + name    = "Microsoft.DBforPostgreSQL/flexibleServers"
            }
        }
    }

  # module.network.azurerm_subnet_network_security_group_association.app will be created
  + resource "azurerm_subnet_network_security_group_association" "app" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # module.network.azurerm_subnet_network_security_group_association.db will be created
  + resource "azurerm_subnet_network_security_group_association" "db" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # module.network.azurerm_virtual_network.vnet will be created
  + resource "azurerm_virtual_network" "vnet" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "eastus2"
      + name                = "assessment-vnet"
      + resource_group_name = "rg-assessment-3tier"
      + subnet              = (known after apply)
    }

Plan: 18 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + lb_ip                   = (known after apply)
  + postgres_admin_password = (sensitive value)
  + postgres_fqdn           = (known after apply)
  + ssh_command             = "ssh adminuser@<instance_ip> -i <path_to_your_private_key>"

───────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these
actions if you run "terraform apply" now.

````
