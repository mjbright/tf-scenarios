# ${comment}
%{ for index, node in node_names ~}

# ${user_prefix}${node_fqdns[index]}:
Host ${user_prefix}${node}
    Hostname      ${node_ips[index]}
    User          ${user}
    IdentityFile  ${key_file}

%{ endfor ~}
