
locals {
    num_nodes        = length(var.node_names)
    public_key_file  = "${ var.admin_private_key_file }.pub"

    # No auto install:
    no_node_install_sh = {
        #"cp":     [ "touch /tmp/cp.installed",     "ls -al /tmp/cp.installed" ],
        #"worker": [ "touch /tmp/worker.installed", "ls -al /tmp/worker.installed" ],
        "cp":     [],
        "worker": [],
    }
}

module cluster {
    source = "./modules/proxmox-cloudinit"

    count  = var.num_clusters

    TEMPLATE       = var.TEMPLATE
    vmid_base      = "${ var.vmid_base + ( count.index * local.num_nodes ) }"
    cluster_prefix = "${ var.cluster_prefix}${ count.index }"

    node_names = var.node_names
    node_state = var.node_state
    node_disk  = var.node_disk 
    node_mem   = var.node_mem  

    node_roles      = var.node_roles
    #node_playbooks  = var.no_node_playbooks
    node_playbooks  = var.node_playbooks
    #node_install_sh = var.node_install_sh
    node_install_sh = local.no_node_install_sh

    user       = var.user
    ip_prefix  = var.ip_prefix
    ip_base    = ( var.ip_base + ( count.index * local.num_nodes ) )
    gw         = var.gw

    user_private_key_file       = var.user_private_key_file
    admin_private_key_file      = var.admin_private_key_file
    user_intra_private_key_file = var.user_intra_private_key_file

    zip_files      = var.zip_files
    user_data_file = var.user_data_file

    pm_target_node = var.pm_nodename

    agent       = var.agent
}

