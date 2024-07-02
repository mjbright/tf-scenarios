#!/usr/bin/env bash

%{ for index, container in containers ~}
# ${index}.
echo "-- Curling to container ${index}:"
curl ${container.networks_advanced.*.ipv4_address[0]}

%{ endfor ~}
