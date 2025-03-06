
# Warming up ... accessing the ip_address field for containers:
output ip {
    #value = docker_container.demo1["c1"].network_data[0].ip_address
    #value = docker_container.demo1["container1"].network_data[0].ip_address
    #value = [ for container in docker_container.demo1 : docker_container.demo1[container["name"]].network_data[0].ip_address ]
    value = [ for container in docker_container.demo1 :
        format("%s => %s", container["name"], docker_container.demo1[ container["name"] ].network_data[0].ip_address ) ]
}

# Output commands to curl to each container on the container ip address on internal port 80:
output int_curl_command {
    #value = [ for container in docker_container.demo1 : container["name"] ]

    value = format("\t%s\n",
        join("\n\t",
            [ for container in docker_container.demo1 :
                "curl ${ docker_container.demo1[ container["name"] ].network_data[0].ip_address }:80"
         ]) )
}

# Output commands to curl to each container on the host ip interfaces, e.g. localhost, on the exposed port:
output ext_curl_command {
    #value = "curl 127.0.0.1:${ var.ext_port }"

    value = format("\t%s\n",
        join("\n\t",
            [ for container in docker_container.demo1 :
                "curl 127.0.0.1:${ docker_container.demo1[ container["name"] ].ports[0]["external"]}"
         ]) )
}

