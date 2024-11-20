
## Common Variables: ==============================================================

variable source_builds {
  default = []
}

variable apt_packages {
  default = ""
}

variable ssh_private_key_file {
  type      = string
  default   = "~/.ssh/packer_ed25519"
}

variable app_name {
  type    = string
  default = "vnc"
}

variable "disk_size" {
  type      = string
  default   = "12G"
}

## Azure Variables: ===============================================================

variable gallery_image_version  {
  type    = string
  default = "0.0.0"
}

variable gallery_resource_group {
  type    = string
  default = "UNSET"
}

variable gallery_name {
  type    = string
  default = "UNSET"
}

variable gallery_image_name {
  type    = string
  default = "UNSET"
}

variable resource_group {
  type    = string
  default = "UNSET"
}

## AWS Variables: =================================================================

variable aws_regions {
  type    = list(string)
  default = ["us-west-1"]
}

variable build_number {
  type    = string
  default = "1.0"
}

variable instance_type {
  type    = string
  default = "medium"
}

variable platform {
  type    = string
  default = "Linux-Ubuntu-24.04"
}

variable subnet_id {
  type    = string
  default = "UNSET"
}

variable vpc_id {
  type    = string
  default = "UNSET"
}

variable shared_account_ids {
  type    = string
  default = "UNSET"
}

variable aws_access_key {
  type    = string
  default = "UNSET"
}

variable aws_secret_key {
  type    = string
  default = "UNSET"
}

## Proxmox Variables: =============================================================

variable proxmox_source_builds {
  default = []
}

variable "pm_node" {
  type    = string
  default = "UNSET"
}

variable "pm_api_url" {
  type    = string
  default = "https://UNSET:8006/api2/json"
}

variable "pm_api_token_id" {
  type    = string
  default = "root@pam!UNSET"
}

variable "pm_api_token_secret" {
  type      = string
  default   = "UNSET"
  sensitive = true
}

