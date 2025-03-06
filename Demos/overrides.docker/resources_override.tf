
resource docker_container server {
  for_each  = var.containers
  
  name      = "TEST-OVERRIDE-${ each.key }"
  hostname  = "${ each.key }.${ var.domain_name }"

  # Note: use image 'id' not 'name' to prevent container re-creation: (due to name vs. sha256 usage)
  #       issue#426 https://github.com/kreuzwerker/terraform-provider-docker/issues/426
  image     = docker_image.image[ each.key ].image_id

  # Shouldn't be necessary: workarounds to prevent unnecessary container re-creations
  #
  # - setting of bridge mode:
  network_mode = "bridge"


  networks_advanced {
    name    = var.network_bridge
  }

  env = var.env

  ports {
    internal = var.int_port
    external = "${ each.value["ext_port"] }"
  }
}
