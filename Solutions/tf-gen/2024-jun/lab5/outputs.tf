
data docker_network network_data {
    # Note: This must be the name of a "docker network" (whether created by Terraform, or not)
    #        View available networks using command:
    #            docker network ls
    name = "app_network"
}

output app_network_detail {
    value = data.docker_network.network_data
}

