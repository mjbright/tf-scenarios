
# -------- Image definitions (will pull images):

resource "docker_image" "image1" {
  count = length( var.images )

  name         = var.images[ count.index ]
  keep_locally = true
}

# -------- Container definitions:

resource "docker_container" "demo1" {
  count    = length( var.images )

  image    = docker_image.image1[ count.index ].image_id

  name     = "${ var.name }-${ count.index }"
  hostname = "${ var.name }-${ count.index }"

  # Shouldn't be necessary: seems to prevent unnecessary container re-creations
  network_mode = "bridge"

  ports {
    internal = 80
    external = var.ext_port + count.index
  }
}

