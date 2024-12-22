%{ for node in node_names ~}

Host u${node}
    Hostname      ${vms[node].public_ip}
    User          ${admin_user}
    IdentityFile  ${admin_key_file}

Host ${node}
    Hostname      ${vms[node].public_ip}
    User          ${user}
    IdentityFile  ${user_key_file}

%{ endfor ~}
