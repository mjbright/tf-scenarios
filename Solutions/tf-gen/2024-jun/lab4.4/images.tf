
resource "docker_image" "k8s-demo" {
  count = 6
  
  name = "mjbright/k8s-demo:${ count.index + 1 }"

  keep_locally = true
}
