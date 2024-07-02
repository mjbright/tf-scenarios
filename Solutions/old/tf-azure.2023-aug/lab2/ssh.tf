
locals {
  ip = azurerm_linux_virtual_machine.vm.public_ip_address
}

locals {
  ssh_config = templatefile("${path.module}/templates/ssh.tpl", {
    node_fqdns = [local.fqdn]
    node_names = [var.hostname]
    node_ips   = [local.ip]
    user       = var.admin_username,
    #key_file   = format("%s/%s", path.cwd, var.admin_priv_key)
    key_file = var.admin_priv_key
  })

}

resource "local_file" "ssh_config" {
  content = local.ssh_config
  #filename  = format("%s/ssh_config", path.cwd)
  filename = pathexpand("~/.ssh/config")
}

