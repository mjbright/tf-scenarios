
output example {
   value = "The value of another is ${ var.another }"
}

output ip {
   value = docker_container.demo1.network_data[0].ip_address
}

output "ips" {
    #value="v4:${docker_container.demo1.network_data[0].ip_address} v6:${docker_container.demo1.network_data[0].ipv6_address}"
    value="v4:${docker_container.demo1.network_data[0].ip_address}"
}

output int_curl_command {
    value = "curl ${ docker_container.demo1.network_data[0].ip_address }:80"
}

output ext_curl_command {
    value = "curl 127.0.0.1:${ var.ext_port }"
}

output container_info {
    value = local.container_info
}
output other_port {
    value = local.other_port
}



output mline1 {
    value = <<-EOF
       #!/bin/bash
       run-microservice.sh
       EOF
}

output mline2 {
    value = <<EOF
       #!/bin/bash
       run-microservice.sh
       EOF
}

