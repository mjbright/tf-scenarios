# ${comment}

%{ for role_index, role in distinct_node_roles ~}
[group_${ role }]
%{ for node_index, node in node_names ~}
%{~ if node_roles[node_index] == role ~}
${ node_fqdns[node_index] } ansible_host="${ node_ips[node_index] }" node_state="${ node_state[node_index] }"

%{~ endif ~}
%{ endfor ~}

%{ endfor ~}

[all:vars]
ansible_connection=ssh
ansible_user=${ user }
ansible_ssh_private_key_file=${ key_file }
# DISABLING breaks (intra-cluster) logins - cluster_ssh_config=${ cluster_ssh_config }

