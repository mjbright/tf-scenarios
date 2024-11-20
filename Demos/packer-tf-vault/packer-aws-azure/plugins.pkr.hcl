
packer {
  required_plugins {

    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }

    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }

    docker = {
      version = ">=v1.0.1"
      source  = "github.com/hashicorp/docker"
    }

    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }

  }
}

