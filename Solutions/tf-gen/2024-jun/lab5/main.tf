
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
}

resource "docker_network" "app_network" {
  name = "app_network"
  driver = "bridge"
}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image     = docker_image.nginx.image_id
  name      = "nginx"
  hostname  = "nginx"

  networks_advanced {
    # Note: name can be the network name or it's id
    # - using id is better as terraform will interpret as an explicit dependency
    #name    = "app_network"
    name    = docker_network.app_network.id
    aliases = ["nginx"]
    #ipv4_address   = "172.17.1.2"
  }

  ports {
    internal = 80
    external = 8000
  }
}

