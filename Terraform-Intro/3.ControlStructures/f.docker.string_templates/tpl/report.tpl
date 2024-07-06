
Congratulations you've just created ${ length( keys( vms ) ) } Virtual Machines
=================================================================================

%{~ for idx, name in keys( vms ) }
${ idx + 1 }. VM Name: '${ name }' -   FQDN: ${ vm_infos[name]["hostname"] }   Private IP address: ${ vm_infos[name]["network_data"][0]["ip_address"] }
          start command: '${ join(" ", vm_infos[name]["command"] ) }'
%{~ endfor }

# NOTE: use terraform state show docker_container.test[\"vm1\"] to see available fields on vm_infos
