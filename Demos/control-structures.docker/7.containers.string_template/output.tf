
output ip {
   #value = docker_container.demo1["c1"].network_data[0].ip_address
   #value = docker_container.demo1["container1"].network_data[0].ip_address

    #value = [ for c in docker_container.demo1 : docker_container.demo1[c["name"]].network_data[0].ip_address ]
    value = [ for c in docker_container.demo1 :
        format("%s => %s", c["name"], docker_container.demo1[c["name"]].network_data[0].ip_address ) ]
}

output int_curl_command {
    #value = [ for c in docker_container.demo1 : c["name"] ]

    value = format("\t%s\n",
        join("\n\t",
            [ for c in docker_container.demo1 :
                "curl ${ docker_container.demo1[c["name"]].network_data[0].ip_address }:80"
         ]) )
}

output ext_curl_command {
    #value = "curl 127.0.0.1:${ var.ext_port }"

    value = format("\t%s\n",
        join("\n\t",
            [ for c in docker_container.demo1 :
                "curl 127.0.0.1:${ docker_container.demo1[c["name"]].ports[0]["external"]}"
         ]) )
}

output summary_report {
    value = templatefile("report.tpl", {
        #containers = docker_container.demo1,
        cs         = var.containers,
        images     = docker_image.image1,
        ext_base   = var.ext_port,
    })
}

#output x { !! value = output.summary_report }

locals {
    summary_report = templatefile("report.tpl", {
        #containers = docker_container.demo1,
        cs         = var.containers,
        images     = docker_image.image1,
        ext_base   = var.ext_port,
    })
}

resource local_file report {
    content  = local.summary_report
    filename = "summary_report.txt"
}


