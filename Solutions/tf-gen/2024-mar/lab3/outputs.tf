
output ip {
    value = docker_container.lab3-c1.network_data[0].ip_address
}

# curl to the container on it's 'docker subnet' and internal port:
output curl_int_port {
    value = "curl -L ${ docker_container.lab3-c1.network_data[0].ip_address }:${ var.int_port }"
}

# curl to the container on the host network (localhost) and external port:
output curl_ext_port {
    value = "curl -L 127.0.0.1:${ var.ext_port }"
}

