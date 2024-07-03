
# Here we define some useful output values, showing information about the generated azurerm_linux_virtual_machine resource
#
# In particular the "example_ssh_command" provides a quick easy way to test connectivity to the resource

locals {
  fqdn = azurerm_public_ip.pip.fqdn
  user = var.admin_username
  ip   = azurerm_linux_virtual_machine.vm.public_ip_address
}

output hostname {
  value = var.hostname
}

output vm_fqdn {
  value = local.fqdn
}

output vm_ip {
  value = local.ip
}

output ssh_command {
  value = "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn}"
}

output example_ssh_command {
  value =  "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'"
}

