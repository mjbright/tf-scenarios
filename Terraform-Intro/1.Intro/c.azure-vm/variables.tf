
# We define a set of variables here
#
# Note that:
# - all variables must be declared ( using a 'variable' block )
#
# - the fields 'description', 'default', 'type' are all optional
#
# - the minimal variable block could be simply:
#      variable resource_group { }
#
# - these definitions could be in any config file but it is recommended to name the files as
#   variables.tf, or vars.tf or something indicating this represents variable definitions
#
# - variable values are defined in terraform.tfvars

variable resource_group {
  description = "The name of the resource group in which to create the resources."
  default     = "terraform-training"
}

variable rg_prefix {
  description = "The shortened abbreviation for the resource group used in naming some resources."
  default     = "rg"
}

variable location {
  description = "The location/region where the virtual network is created"
  default     = "southcentralus"
}

variable hostname {
  description = "VM name referenced also in storage-related names."
}

variable dns_name {
  description = " Label for the Domain Name - used to make up the FQDN."
}

variable virtual_network_name {
  description = "The name for the virtual network."
}

variable address_space {
  description = "Address space used by the virtual network"
}

variable subnet_prefix {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable storage_account_tier {
  description = "Tier of storage account - Standard or Premium."
}

variable storage_replication_type {
  description = " Replication Type of storage account - LRS, GRS etc."
}

variable vm_size {
  description = "Specifies the size of the virtual machine."
}

variable image_publisher {
  description = "name of the publisher of the image (az vm image list)"
}

variable image_offer {
  description = "the name of the offer (az vm image list)"
}

variable image_sku {
  description = "image sku to apply (az vm image list)"
}

variable image_version {
  description = "version of the image to apply (az vm image list)"
}

variable admin_username {
  description = "administrator user name"
}

variable admin_priv_key {
  description = "administrator private key (recommended to disable password auth)"
}

