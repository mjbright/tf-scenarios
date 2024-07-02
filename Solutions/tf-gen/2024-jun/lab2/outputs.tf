
output info {
    value = "The container ${ var.name } was created from image ${ var.image } and exposed on port ${ var.ext_port }"
}

output connect {
  value = "Connect to the container using the command 'curl http://127.0.0.1:${ var.ext_port }'"
}

