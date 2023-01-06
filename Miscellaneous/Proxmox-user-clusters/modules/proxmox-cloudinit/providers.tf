
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      #version = "~> 2.9"
      #version = ">2.8.0, <2.9.0"
      version = ">= 2.8.0, < 2.8.10"
    }
  }
}

