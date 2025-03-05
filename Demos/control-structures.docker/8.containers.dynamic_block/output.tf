
output c_ips {
    value = [ for c in docker_container.c : c.network_data[0].ip_address ]
}

output int_curl_cmds {
    value = [ for c in docker_container.c :
                { for idx,n in c.network_data :  "${c["name"]} network-${idx}" => "curl ${ n["ip_address"] }"  }
            ]
    
}


