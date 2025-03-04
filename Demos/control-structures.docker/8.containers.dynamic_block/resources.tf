
# -------- Image definitions (will pull images):
resource docker_image image {
  count        = length( var.image_names )

  name         = var.image_names[ count.index ]
  keep_locally = true
}

# -------- Container definitions:

resource docker_container c {
  count    = var.container_count

  image    = ( length(var.image_names) == 1 ?
                 docker_image.image[0].image_id :
                 docker_image.image[ count.index ].image_id
             )
  name     = "${ var.container_name_prefix }-${ count.index }"
  hostname = "${ var.container_name_prefix }-${ count.index }"

  dynamic networks_advanced {
    for_each = ( var.network_name == null ? {} : { "${ var.network_name }": true } )
    #for_each = toset( var.test )

    content {
      name = networks_advanced.key
      aliases = [ networks_advanced.key ]
    }
  }

  ports {
    internal = 80
    external = 8000 + count.index
  }
}

