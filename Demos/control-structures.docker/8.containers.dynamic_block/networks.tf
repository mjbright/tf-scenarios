
resource "docker_network" "app_network" {
  for_each = var.networks

  name   = each.key
  driver = "bridge"
}

