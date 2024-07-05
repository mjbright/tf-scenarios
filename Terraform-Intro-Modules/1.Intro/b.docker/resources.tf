
# -------- Variable definitions:

variable "image" {
  type        = string
  description = "The name of the Container Image to use"
  default     = "mjbright/k8s-demo:alpine1"
}

variable "name" {
  type        = string
  description = "The name of the Container to create"
  default     = "container1"
}

variable "ext_port" {
  type        = number
  description = "The port on which the application will be exposed (on the node ip address)"
  default     = 8001
}

# -------- Image definitions (will pull images):

# Note: the name image1 will be used by Terraform to refer to this resource as docker_image.image1

resource "docker_image" "image1" {
  name         = var.image

  force_remove = false
}

# -------- Container definitions:

# Note: the name c1 will be used by Terraform to refer to this resource as docker_container.c1

resource "docker_container" "c1" {
  image    = docker_image.image1.image_id
  name     = var.name
  hostname = var.name

  # The container listens on port 80 on the Docker bridged network
  # we want to expose this on a port (8081) on the host network
  ports {
    internal = 80
    external = var.ext_port
  }
}

