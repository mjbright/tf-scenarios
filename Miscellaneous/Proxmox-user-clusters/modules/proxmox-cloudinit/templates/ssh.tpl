# ${comment}
%{ for index, node in node_names ~}

Host ${user_prefix}${node_fqdns[index]}
    Hostname      ${node_ips[index]}
    User          ${user}
    IdentityFile  ${key_file}

%{ endfor ~}
