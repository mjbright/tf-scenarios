
# These are outputing variable values:
output info {
    value = "The container ${ var.name } was created from image ${ var.image } and exposed on port ${ var.ext_port }"
}

output connect {
  value = "Connect to the container using the command 'curl http://127.0.0.1:${ var.ext_port }'"
}

# This is outputing an attribute of the created resource, not known in advance:
# Note: use of docker_container.c1 to identify the resources,
#       then use of network_data[0].ip_address to access the attribute
output bridged_ip {
    value = docker_container.c1.network_data[0].ip_address
}
