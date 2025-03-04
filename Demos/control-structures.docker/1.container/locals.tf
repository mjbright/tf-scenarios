
locals {
    container_info = "IP address=${ docker_container.demo1.network_data[0].ip_address }\n curl 127.0.0.1:${ var.ext_port }"

    other_port     = var.ext_port+1
}








