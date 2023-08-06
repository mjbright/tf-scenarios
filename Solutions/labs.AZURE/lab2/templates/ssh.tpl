
%{ for index, node in node_names ~}

# ${node_fqdns[index]}:
Host ${node}
    Hostname      ${node_ips[index]}
    User          ${user}
    IdentityFile  ${key_file}

%{ endfor ~}

