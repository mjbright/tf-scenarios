packer {
  required_plugins {

    docker = {
      version = ">=v1.0.1"
      source  = "github.com/hashicorp/docker"
    }

    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }

  }
}
