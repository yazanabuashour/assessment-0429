variable "prefix" {
  type        = string
  description = "Name prefix for all resources"
  default     = "assessment"
}

variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group name"
  default     = "rg-assessment-3tier"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus2"
}

variable "vnet_cidr" {
  type        = string
  description = "VNet address space"
  default     = "10.0.0.0/16"
}

variable "app_subnet_cidr" {
  type        = string
  description = "App subnet CIDR"
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  type        = string
  description = "DB subnet CIDR"
  default     = "10.0.3.0/24"
}

variable "admin_username" {
  type        = string
  description = "SSH admin user for VMSS"
  default     = "adminuser"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
  sensitive   = true
}

variable "postgres_admin_username" {
  type        = string
  description = "PostgreSQL admin user"
  default     = "postgresadminun"
}

variable "instance_count" {
  type        = number
  description = "VMSS instance count"
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "Size of VMSS instances"
  default     = "Standard_A1_v2"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default = {
    env     = "assessment"
    project = "3tier"
  }
}

