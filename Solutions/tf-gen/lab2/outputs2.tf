
output bridged_ip {
    value = docker_container.demo1.network_data[0].ip_address
}

