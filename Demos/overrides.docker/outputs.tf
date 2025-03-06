
output ip_addresses {
    value = { for idx, c in keys( docker_container.server ) :
                c => docker_container.server[c].network_data[0].ip_address }
}

output ext_ports {
    value = { for idx, c in keys( docker_container.server ) :
                c => var.containers[c].ext_port }
}


