output "lb_ip" {
  description = "Public IP of LB"
  value       = module.app.lb_public_ip
}

output "postgres_fqdn" {
  description = "FQDN of DB"
  value       = module.db.postgres_fqdn
}

output "postgres_admin_password" {
  description = "Admin password for DB"
  value       = module.db.postgres_admin_password
  sensitive   = true
}

output "ssh_command" {
  description = "SSH into instance"
  value       = "ssh ${var.admin_username}@<instance_ip> -i <path_to_your_private_key>"
}

