
resource docker_network app_network {
  name   = var.network_bridge
  driver = "bridge"
}

