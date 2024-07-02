
# Pulls the image
resource "docker_image" "demo-image" {
  name = var.image_name
}

# Create a container
resource "docker_container" "lab3-c1" {
  image = docker_image.demo-image.image_id
  name  = var.container_name

  ports {
    internal = var.int_port
    external = var.ext_port
  }
}

