
# -------- Image definitions (will pull images):

resource "docker_image" "image1" {
  name = var.image

  keep_locally = true
}

# -------- Container definitions:

resource "docker_container" "demo1" {
  image    = docker_image.image1.image_id
  name     = var.name
  hostname = var.name

  ports {
    internal = 80
    external = var.ext_port
  }
}

