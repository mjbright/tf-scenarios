
resource "docker_image" "k8s-demo" {
  for_each = var.container_details

  name = format("%s:%s", "mjbright/k8s-demo", each.value["image"])
}
