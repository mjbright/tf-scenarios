
resource "docker_image" "image1" {
  name = "mjbright/k8s-demo:alpine1"

  keep_locally = true
}

resource docker_container "server" {
  count     = length( var.container_names )
  
  image     = docker_image.image1.image_id
  name      = var.container_names[ count.index ]
  hostname  = "${ var.container_names[ count.index ] }.${ var.domain_name }"

  networks_advanced {
    name    = "apps"
  }

  ports {
    internal = 80
    external = "${ 8001 + count.index}"
  }
}
