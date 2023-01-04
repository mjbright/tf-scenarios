
variable TEMPLATE {
    type = string
    #default = ""
}

variable pm_target_node {
    type = string
    default = ""
}

variable node_roles {
  type = list(string)
}

variable node_playbooks {
  type = map( list(string) )
}

variable node_install_sh {
  type = map( list(string) )
}

variable agent {
    type = number
    default = 1
}

variable vmid_base {
    type = number
    #default = ""
}

variable cluster_prefix {
    type = string
    default = "cluster"
}

variable node_names {
    type = list(string)
    #default = ""
}

variable node_state {
    type = list(string)
    #default = ""
}

variable node_disk {
    type = list(string)
    #default = ""
}

variable node_mem {
    type = list(number)
    #default = ""
}

variable user {
    type = string
    default = "ubuntu"
}

variable ip_prefix {
    type = string
    default = "192.168.0"
}

variable ip_base {
    type = number
    default = 80
}

variable gw {
    type = string
    default = "192.168.0.254"
}

variable admin_private_key_file {
    type = string
    default = "~/.ssh/id_rsa"
    # pathexpand( var.private_key_file )
}

variable user_private_key_file {
    type = string
    default = "~/.ssh/id_rsa"
    # pathexpand( var.private_key_file )
}

variable user_intra_private_key_file {
    type = string
}

variable user_data_file {
    type = string
}

variable zip_files {
    type = list(string)
}



