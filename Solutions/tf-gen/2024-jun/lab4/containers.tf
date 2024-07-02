
# Create containers
resource "docker_container" "test1" {
  for_each = var.container_details
    
  image = docker_image.k8s-demo[ "${ tonumber(each.key) }" ].image_id 
  name  = each.value["container_name"]
  
  networks_advanced {
      name         = "my_bridge"
      ipv4_address = format("%s.%s", "172.18.0", each.value["ipv4_port"])
  }

  ports {
    internal = 80
    external = each.value["ext_port"]

  }
}
