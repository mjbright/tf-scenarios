
# Creating our own network will allow to explicitly assign ip addresses to it:
resource "docker_network" "private_network" {
  name   = "my_bridge"
  driver = "bridge"
  ipam_config {    subnet="172.18.0.0/16"  }
}

