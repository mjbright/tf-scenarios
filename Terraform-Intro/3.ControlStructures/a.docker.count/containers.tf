
variable container_names {
    default = [ "c1", "c2", "c3", "c4", "c5" ]
}

resource docker_image k8s-demo {
  name = "mjbright/k8s-demo:1"
  force_remove = false
}

resource docker_container test {
    count = length( var.container_names)

    image = docker_image.k8s-demo.image_id

    #name  = "test-count-${ var.container_names[ count.index ] }"
    name  = var.container_names[ count.index ]
}


