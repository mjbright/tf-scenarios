
variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "terraform-training"
}
variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "rg"
}
variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "southcentralus"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
}
variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
}
variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
}
variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
}
variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
}
variable "vm_size" {
  description = "Specifies the size of the virtual machine."
}
variable "image_id" {
  description = "Source Image Id"
}
variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
}
variable "image_offer" {
  description = "the name of the offer (az vm image list)"
}
variable "image_sku" {
  description = "image sku to apply (az vm image list)"
}
variable "image_version" {
  description = "version of the image to apply (az vm image list)"
}
variable "admin_username" {
  description = "administrator user name"
}
variable "admin_priv_key" {
  description = "administrator private key (recommended to disable password auth)"
}

