
locals {
    distinct_node_roles = distinct(var.node_roles)

    node_fqdns = [ for n, node_name in var.node_names.* : "${var.cluster_prefix}-${node_name}" ]

    admin_private_key_file = pathexpand( var.admin_private_key_file )
    admin_public_key_file  = "${ local.admin_private_key_file }.pub"

    user_private_key_file = pathexpand( var.user_private_key_file )
    user_public_key_file  = "${ local.user_private_key_file }.pub"
    r_public_key_file = "/tmp/${ basename( local.user_public_key_file ) }"

    user_intra_private_key_file = pathexpand( var.user_intra_private_key_file )
    user_intra_public_key_file  = "${ local.user_intra_private_key_file }.pub"
    l_key_file         = ".ssh/${ basename( local.user_intra_private_key_file ) }"
    l_public_key_file  = ".ssh/${ basename( local.user_intra_public_key_file ) }"
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = length(var.node_names)

  # Timeout after 2 mins if provider times out ...
  # Deprecated: guest_agent_ready_timeout = 120
  # https://www.terraform.io/docs/language/resources/syntax.html#operation-timeouts
  timeouts {
    create = "20m"
    delete = "2h"
  }

  target_node       = var.pm_target_node

  agent             = 1

  name              = local.node_fqdns[ count.index ]
  #name              = "${ var.cluster_prefix }-${ var.node_names[count.index] }"
  #name              = var.node_names[count.index]
  vmid              = "${ var.vmid_base + count.index }"
  clone             = var.TEMPLATE
  os_type           = "cloud-init"
  cores             = 4
  memory            = var.node_mem[count.index]
  sockets           = "1"
  cpu               = "host"
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  full_clone        = false

  # Setup keyless login for ubuntu - needed for ansible ...
  provisioner "local-exec" {
    command =<<EOF
      mkdir -p var
      [ -f ~/.ssh/known_hosts ] && {
          ssh-keygen -f ~/.ssh/known_hosts -R ${self.default_ipv4_address}  
          ssh-keygen -f ~/.ssh/known_hosts -R ${local.node_fqdns[count.index]}
      } > var/ssh.keygen.${count.index}.op 2>&1

      {
          ssh-keyscan -t rsa ${self.default_ipv4_address}   
          ssh-keyscan -t rsa ${local.node_fqdns[count.index]}
      } >> ~/.ssh/known_hosts 2>var/ssh.keyscan.${count.index}.op

      cat ~/.ssh/known_hosts

      exit 0
      EOF
  } 

  connection {
    type        = "ssh"
    host        = self.default_ipv4_address
    user        = var.user
    private_key = file( local.admin_private_key_file )
  }
  sshkeys = file( local.admin_public_key_file )

  provisioner "file" {
    source       = var.user_data_file
    destination  = "/tmp/remote-exec.sh"
  }

  # Transfer up to 4 zip files if specified in var.zip_files:
  provisioner "file" {
    source      = ( var.zip_files[0] == "" ? "/dev/null"  : var.zip_files[0] )
    destination = ( var.zip_files[0] == "" ? "/tmp/.null" : "/tmp/files1.zip" )
  }
  provisioner "file" {
    source      = ( var.zip_files[1] == "" ? "/dev/null"  : var.zip_files[1] )
    destination = ( var.zip_files[1] == "" ? "/tmp/.null" : "/tmp/files2.zip" )
  }
  provisioner "file" {
    source      = ( var.zip_files[2] == "" ? "/dev/null"  : var.zip_files[2] )
    destination = ( var.zip_files[2] == "" ? "/tmp/.null" : "/tmp/files3.zip" )
  }
  provisioner "file" {
    source      = ( var.zip_files[3] == "" ? "/dev/null"  : var.zip_files[3] )
    destination = ( var.zip_files[3] == "" ? "/tmp/.null" : "/tmp/files4.zip" )
  }

  provisioner "remote-exec" {

    inline = [
        # First do node setup in foreground:
        "sudo hostnamectl set-hostname ${ var.node_names[count.index] }",
        "chmod +x /tmp/remote-exec.sh",
        "sudo /tmp/remote-exec.sh ${ var.cluster_prefix }-${ var.node_names[count.index] } setup1",

       # Don't fail all nodes if script fails on this node:
       "exit 0"
    ]
  }

  # To do after unzipping filesN.zip
  #      Transfer intra-node keys + config (ssh_config and part of etc/hosts)
  provisioner "file" {
    source      = local.user_intra_private_key_file
    destination = local.l_key_file
  }

  provisioner "file" {
    source      = local.user_intra_public_key_file
    destination = local.l_public_key_file
  }

  provisioner "file" {
    source      = local.user_public_key_file
    destination = local.r_public_key_file
  }

  vga {
    type = "qxl,memory=16"
  }

  disk {
    #size            = "4G" # Extend from 4G
    size            = var.node_disk[count.index]
    type            = "scsi"
    storage         = "local-lvm"
    discard         = "on"
  }

  network {
    model           = "virtio"
    bridge          = "vmbr0"
  }

  # Cloud Init Settings
  ipconfig0 = "ip=${ var.ip_prefix }.${ var.ip_base + count.index }/24,gw=${ var.gw }"
  #ipconfig0 = "ip=192.168.0.89/24,gw=192.168.0.254"
  #ipconfig0 = "ip=dhcp"
}

resource "null_resource" "intra_ssh_setup" {
  count = length(var.node_names)

  # Changes to ssh_config for this cluster triggers recreation/remote-exec
  triggers = {
    hosts_updated = local_file.intra_ssh_config.content
    ## To force recreation of null_resource at each apply:
    ## ip = local.random_id
  }

  # depends_on = [ local.intra_ssh_config_file, local.intra_etc_hosts_file, ]

  provisioner "file" {
    source      = local.intra_ssh_config_file
    destination = "/tmp/student.ssh.config"
  }

  provisioner "file" {
    source      = local.intra_etc_hosts_file
    destination = "/tmp/student.etc.hosts"
  }

  # Run on all nodes, built previously via count perhaps
  connection {
    host = "${element( proxmox_vm_qemu.proxmox_vm.*.default_ipv4_address, count.index)}"
    user        = var.user
    private_key = file( local.admin_private_key_file )
  }
  
  # TO do after copying across local ssh config/keys:
  # TODO: reimplement with ansible
  provisioner "remote-exec" {
    # Run service restart on each node in the cluster
    inline = [
        "sudo /tmp/remote-exec.sh ${ var.cluster_prefix }-${ var.node_names[count.index] } setup2",

        # Then optionally do platform setup:

       ( length(var.node_install_sh[ var.node_roles[count.index] ]) != 0 ? 
         join("; ", [
           "set -x",
           join("; ", var.node_install_sh[ var.node_roles[count.index] ] )
           ]
          )
          :
          "echo SKIPPING node_install_sh for role '${ var.node_roles[count.index] }'"
       ),

       # Don't fail all nodes if script fails on this node:
       "exit 0"
    ]
  }
}

resource "null_resource" "run_ansible" {
  count = length( local.distinct_node_roles )

  # Changes to ansible_hosts for this cluster triggers recreation/remote-exec
  triggers = {
    hosts_updated = local_file.ansible_hosts.content
  }
  ## depends_on = [ local.intra_ssh_config_file, local.intra_etc_hosts_file, ]

  provisioner "local-exec" {
    command = "echo == RUN_ANSIBLE ======================================================="
  }

  provisioner "local-exec" {
    command = ( ( length(var.node_playbooks[ local.distinct_node_roles[ count.index ] ]) != 0 ) ? 
        join("; ", [
            "( set -x",
            "cat var/ansible_hosts.${ var.cluster_prefix } | tee var/ansible_hosts.latest",
            "ansible -v -i var/ansible_hosts.${ var.cluster_prefix } --limit group_${ local.distinct_node_roles[count.index] } -u ubuntu -m ping all 2>&1",
            join(" ", [
                 "ansible-playbook -v -i var/ansible_hosts.${ var.cluster_prefix } --limit group_${ local.distinct_node_roles[count.index] }",
                 join(" ", var.node_playbooks[ local.distinct_node_roles[ count.index ] ]),
                 " ) 2>&1 | stdbuf -oL -eL tee var/ansible.${ var.cluster_prefix }.${ local.distinct_node_roles[ count.index ] }.log" ]),
          ])
         :
         "echo SKIPPING ansible-playbook for role '${ local.distinct_node_roles[count.index] }'"
     )
  } 

  provisioner "local-exec" {
    command = "echo == DONE RUN_ANSIBLE ======================================================="
  }
}
