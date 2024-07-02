
resource "docker_image" "k8s-demo" {
  count = ( var.day_of_week == "Tuesday" ? 1 : 0 )

  name = "mjbright/k8s-demo:1"
}

