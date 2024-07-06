
output result {
    value = "Container has ip address ${ docker_container.demo1.network_data[0].ip_address } on network '${ docker_container.demo1.network_data[0].network_name }'"
}

