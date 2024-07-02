
locals {
  ansible_hosts = templatefile("${path.module}/templates/ansible.tpl", {
      node_fqdns = [ local.fqdn ]
      node_names = [ var.hostname ]
      node_ips   = [ local.ip ]
      user       = var.admin_username,
      key_file   = var.admin_priv_key
  })
}

output ansible_hosts {
    value = local.ansible_hosts
}

resource "local_file" "ansible_inventory" {
    content   = local.ansible_hosts
    #filename  = format("%s/ansible_inventory", path.cwd)
   filename  = pathexpand("~/ansible_inventory")
}

