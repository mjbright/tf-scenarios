
variable day_of_week {
  default = "Monday"
}

# Create containers
resource "docker_container" "only-on-tuesdays" {
  # USING the ternary operator to determine if the container is created or not:
  count = ( var.day_of_week == "Tuesday" ? 1 : 0 )
  
  image = docker_image.k8s-demo[ count.index ].image_id
  name  = "test-count-${ count.index }"
  
  networks_advanced {
      name         = "my_bridge"
      ipv4_address = "172.18.0.${ 80 + count.index }"
  }

  ports {
    internal = 80
    external = "909${ count.index }"
  }
}
