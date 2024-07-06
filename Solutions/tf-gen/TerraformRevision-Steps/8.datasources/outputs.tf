
output result_1_name {
    value = join("\n", [ for c in docker_container.server :
      "Container ${ c.name } [${ c.hostname }] has ip address ${ c.network_data[0].ip_address } on network '${ c.network_data[0].network_name }'"
        ])
}

output result_2_idx {
    value = join("\n", [ for idx, c in keys( docker_container.server ) :
      format("%d: %s", idx,
        "Container ${ docker_container.server[c].name } [${ docker_container.server[c].hostname }] has ip address ${ docker_container.server[c].network_data[0].ip_address } on network '${ docker_container.server[c].network_data[0].network_name }'")
        ])
}

