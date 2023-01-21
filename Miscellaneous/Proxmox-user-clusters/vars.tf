
variable num_clusters {
  type    = number
  default = 1
}

variable pm_api_url {
  default = "http://pm_api_url_default"
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

variable admin_private_key_file {
  default = "~/.ssh/id_rsa"
  type = string
}

variable user_private_key_file {
  default = "~/.ssh/id_rsa"
  type = string
}

variable user_intra_private_key_file {
  default = "~/.ssh/id_rsa"
  type = string
}

variable pm_nodename {
  description = "Node name of node on which to deploy the VM"
  type = string
}

variable "user" {
  type = string
}

variable "user_data_file" {
  type = string
}

variable "zip_files" {
  type = list(string)
}

variable TEMPLATE {
  type = string
  default = "TEMPLATE-ubuntu2004"
}

variable cluster_prefix {
  type = string
  default = "cluster"
}
variable node_names {
  type = list(string)
}
variable node_state {
  type = list(string)
}
variable node_disk {
  type = list(string)
}
variable node_mem {
  type = list(number)
}
variable node_cores {
  type = list(number)
}

variable vmid_base {
  type = number
  default = 20200
}

variable ip_prefix {
  type = string
  default = "192.168.0"
}
variable ip_base {
  type = number
  default = 200
}
variable gw {
  type = string
  default = ""
}

variable agent {
  type = number
  default = 1
}


