
locals {
  ssh_config_u = templatefile("${path.module}/templates/ssh.tpl", {
      comment    = "# Cluster ${ var.cluster_prefix } - ssh_config_u",
      user_prefix= "u",
      node_fqdns = local.node_fqdns,
      node_names = var.node_names,
      node_ips   = proxmox_vm_qemu.proxmox_vm.*.default_ipv4_address,
      user       = "ubuntu",
      key_file   = var.admin_private_key_file
  })

  ssh_config_s = templatefile("${path.module}/templates/ssh.tpl", {
      comment    = "# Cluster ${ var.cluster_prefix } - ssh_config_s",
      user_prefix= "",
      node_fqdns = local.node_fqdns,
      node_names = var.node_names,
      node_ips   = proxmox_vm_qemu.proxmox_vm.*.default_ipv4_address,
      user       = "student",
      key_file   = var.user_private_key_file
  })

  # TO connect to users cluster:
  cluster_ssh_config_s = templatefile("${path.module}/templates/ssh_user.tpl", {
      comment    = "# Cluster ${ var.cluster_prefix } - cluster_ssh_config_s",
      user_prefix= "",
      node_fqdns = var.node_names,
      node_names = var.node_names,
      node_ips   = proxmox_vm_qemu.proxmox_vm.*.default_ipv4_address,
      user       = "student",
      key_file   = var.user_private_key_file
  })

  # TO connect between user nodes:
  intra_ssh_config_s = templatefile("${path.module}/templates/ssh_user.tpl", {
      comment    = "# Cluster ${ var.cluster_prefix } - intra_ssh_config_s",
      user_prefix= "",
      node_fqdns = var.node_names,
      node_names = var.node_names,
      node_ips   = proxmox_vm_qemu.proxmox_vm.*.default_ipv4_address,
      user       = "student",
      #key_file   = var.user_intra_private_key_file
      key_file   = "/home/student/.ssh/intra_ed25519"
  })

  intra_ssh_config_file = "var/intra_ssh_config.${ var.cluster_prefix }"
  intra_etc_hosts_file  = "var/intra_etc.hosts.${ var.cluster_prefix }"

  ssh_config = join("\n", [
      "# ${ var.cluster_prefix } - admin logins", local.ssh_config_u,
      "# ${ var.cluster_prefix } - user logins",  local.ssh_config_s])

  cluster_trainer_ssh_config_file = "${path.root}/var/config.${ var.cluster_prefix }"
  cluster_ssh_config_file         = "${path.root}/var/config.${ var.cluster_prefix }.user"
}

output ssh_config {
    value = local.ssh_config
}

resource "local_file" "ssh_config" {
    content  = local.ssh_config
    filename = local.cluster_trainer_ssh_config_file
}

resource "local_file" "cluster_ssh_config" {
    content  = local.cluster_ssh_config_s
    filename = "${ local.cluster_ssh_config_file }"
}

resource "local_file" "intra_ssh_config" {
    content  = local.intra_ssh_config_s
    filename = "${ local.intra_ssh_config_file }"
}

#join("\n", [ for idx, node in var.node_names : "${local.node_ips[idx]} ${node}" ])
#join("\n", [ for idx, node in var.node_names : "${ proxmox_vm_qemu.proxmox_vm[idx].default_ipv4_address } ${node}" ])
resource "local_file" "intra_etc_hosts" {
    content  = format("\n%s\n", 
        join("\n", [ for idx, node in proxmox_vm_qemu.proxmox_vm.*.default_ipv4_address : "${ node } ${var.node_names[idx] }" ])
    )
    filename = "${ local.intra_etc_hosts_file }"
}

