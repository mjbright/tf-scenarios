
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # We can refer to the host as defined in our ~/.ssh/config file:
  # host = "ssh://vmadmin@vm-linux-docker"

  # We can specify full ssh options here
  # - if doing this be sure to use the correct fqdn, not with 'studentn':
  # host     = "ssh://vmadmin@studentn.eastus.cloudapp.azure.com:22"
  # ssh_opts = ["-i", "~/.ssh/test_rsa", "-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

