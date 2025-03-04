
output ip {
   value = docker_container.demo1[0].network_data[0].ip_address
}

output int_curl_command {
    value = "curl ${ docker_container.demo1[0].network_data[0].ip_address }:80"
}

output ext_curl_command {
    value = "curl 127.0.0.1:${ var.ext_port }"
}

