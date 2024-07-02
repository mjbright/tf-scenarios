
resource "docker_network" "app_network" {
  name   = "apps"
  driver = "bridge"
}

