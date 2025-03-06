
terraform {
  required_providers {
    docker = {
      /* https://registry.terraform.io/providers/kreuzwerker/docker/latest */
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}
