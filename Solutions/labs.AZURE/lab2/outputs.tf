locals {
  fqdn = azurerm_public_ip.pip.fqdn
  user = var.admin_username
}

output "hostname" {
  value = var.hostname
}

output "vm_fqdn" {
  value = local.fqdn
}

output "vm_ip" {
  value = local.ip
}

output "ssh_command" {
  value = "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn}"
}

output "example_ssh_command" {
  value = "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) - $(uptime)'"
}
