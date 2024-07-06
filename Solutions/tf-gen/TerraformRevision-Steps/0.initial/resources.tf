
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

resource "docker_image" "image1" {
  name = "mjbright/k8s-demo:alpine1"

  keep_locally = true
}

resource "docker_container" "demo1" {
  image     = docker_image.image1.image_id
  name      = "demo1"
  hostname  = "demo1"

  ports {
    internal = 80
    external = 8000
  }
}

