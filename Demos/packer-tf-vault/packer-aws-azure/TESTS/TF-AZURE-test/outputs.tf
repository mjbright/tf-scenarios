
locals {
    ip = azurerm_linux_virtual_machine.vm.public_ip_address

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

output "ssh_cnxn_vmadmin" {
  value = "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn}"
}

output "ssh_cnxn_ubuntu" {
  value = "ssh -i ~/.ssh/packer_ed25519 ubuntu@${local.fqdn}"
}

output "ssh_cnxn_ubuntu_2" {
  value = "ssh -i ~/.ssh/labs/lab43_admin_ed25519 ubuntu@${local.fqdn}"
}

output "ssh_cnxn_student" {
  value = "ssh -i ~/.ssh/labs/lab43_ed25519 student@${local.fqdn}"
}

output "ssh_hello_vmadmin" {
  value =  "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'"
}

output "ssh_hello_vmadmin_no_docker" {
  value =  "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(docker ps) $(docker --version) $(uptime)'"
}

output "ssh_hello_ubuntu" {
  value = "ssh -i ~/.ssh/labs/lab43_admin_ed25519 ubuntu@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(docker ps) $(docker --version) $(uptime)'"
}

output "ssh_hello_student" {
  value = "ssh -i ~/.ssh/labs/lab43_ed25519 student@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(docker ps) $(docker --version) $(uptime)'"
}


