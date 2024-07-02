
variable location {
  description = "Azure region (location) in which to create resources"
}

variable virtual_network_name {
    default = "test-net"
}

variable key_file {
  description = "Path to generated PEM key file"
}

variable resource_group {
  description = "Existing resource group name"
}

variable key_ppk_file {
    default = "key.ppk"
}

variable user {
  description = "Login user"
  default     = "ubuntu"
}

variable ami_family {
  description = "AMI family to search for AWS images - ignored if var.ami is set"
  default     = "ubuntu_2004"
}

variable ami {
  description = "Specific AMI to use"
  default     = ""
}

variable nodes {
  description = "Number of VMs"
  default     = 1
}

variable pub_ingress_ports {
  description = "Public Ingress Ports"
  type        = map(list(number))
}

variable vpc_ingress_ports {
  description = "VPC Ingress Ports"
  type        = map(list(number))
}

variable egress_ports {
  description = "Egress Ports"
  type        = map(list(number))
}

variable host {
  description = "DNS host name"
  type        = string
}

variable net_cidr {
  description = "CIDR range to use for virtual network"
}

variable subnet_cidr {
  description = "CIDR range to use for internal subnet within the virtual network"
}

variable user_data_file {
  description = "Optional path to user_data for VM provisioning"
  type        = string
}

variable provisioner_templatefile {
  description = "Optional path to provisioner_templatefile for file cp, then execution"
  type        = string
}

variable files_to_transfer {
  type        = list(string)
}

variable intra_pub_key_file {
  description = "optional: public key file to provide for connection between cluster nodes within a group"
  default     = ""
}

variable intra_key_file {
  description = "optional: provided key file to provide for connection between cluster nodes within a group"
  default     = ""
}

variable vm_size {
  # See https://azure.microsoft.com/en-us/pricing/vm-selector/
  description = "The Azure Region to use"
}

variable image_publisher {
  description ="Publisher of VM image to use, e.g. Canonical for generic Ubuntu images"
}

variable image_offer {
  description ="Which class of image to use, e.g. UbuntuServer"
}

variable image_sku {
  description ="Image SKU to use"
}

variable image_version {
  description ="Which version to choose, e.g. 'latest' build"
}

variable prefix {
  description = "The prefix used for all resource names"
}

