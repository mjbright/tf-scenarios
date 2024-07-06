
resource docker_image image {
  for_each     = var.containers
  
  name         = each.value["image"]

  keep_locally = true
}

resource docker_container server {
  for_each  = var.containers
  
  image     = docker_image.image[ each.key ].name
  
  name      = each.key
  hostname  = "${ each.key }.${ var.domain_name }"

  networks_advanced {
    name    = "apps"
  }

  ports {
    internal = var.int_port
    external = "${ each.value["ext_port"] }"
  }
}
