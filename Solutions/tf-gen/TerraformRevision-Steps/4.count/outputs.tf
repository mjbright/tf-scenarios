
output result {
  value = join("\n", [ for idx, c in docker_container.server :
      format("%d: %s", idx,
        "Container ${ c.name } [${ c.hostname }] has ip address ${ c.network_data[0].ip_address } on network '${ c.network_data[0].network_name }'")
        ])
}

