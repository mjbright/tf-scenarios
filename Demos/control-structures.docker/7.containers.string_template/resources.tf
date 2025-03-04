
# -------- Image definitions (will pull images):

resource "docker_image" "image1" {
  count = length( var.images )

  name         = var.images[ count.index ]
  keep_locally = true
}

# -------- Container definitions:

resource "docker_container" "demo1" {
  for_each = var.containers

  #count    = length( var.images )

  image    = docker_image.image1[ each.value[0] ].image_id

  name     = each.key
  hostname = each.key

  # Shouldn't be necessary: seems to prevent unnecessary container re-creations
  network_mode = "bridge"

  ports {
    internal = 80
    external = var.ext_port + each.value[1]
  }
}



variable containers {
  # type = map(list(number))

  default = {
    # name: [ image_idx, port_increment ]
    "c1": [ 0, 10 ],
    "c2": [ 0, 11 ],
    "c3": [ 2, 12 ],
    "c4": [ 2, 13 ],
    "c5": [ 4, 14 ],
    "c6": [ 4, 15 ],
  }
}



