
locals {
  ansible_hosts = templatefile("${path.module}/templates/ansible_hosts.tpl", {
      comment    = "ansible_hosts",
      cluster_ssh_config = local.cluster_ssh_config_file,
      node_fqdns = local.node_fqdns,
      node_roles = var.node_roles,
      distinct_node_roles = local.distinct_node_roles,
      node_names = var.node_names,
      node_state = var.node_state,
      node_ips   = proxmox_vm_qemu.proxmox_vm.*.default_ipv4_address,
      user       = "ubuntu",
      key_file   = local.admin_private_key_file
  }) 

  ansible_vars = templatefile("${path.module}/templates/ansible_vars.tpl", {
      comment    = "ansible_vars",
    ssh_key_admin = local.admin_private_key_file
    ssh_key_users = local.user_private_key_file
  })
}

#output ansible_hosts { value = local.ansible_hosts }

resource "local_file" "ansible_hosts" {
    content  = local.ansible_hosts
    filename = "${path.root}/var/ansible_hosts.${var.cluster_prefix}"
}

resource "local_file" "ansible_vars" {
    content  = local.ansible_vars
    filename = "${path.root}/var/ansible_vars.yaml"
}




