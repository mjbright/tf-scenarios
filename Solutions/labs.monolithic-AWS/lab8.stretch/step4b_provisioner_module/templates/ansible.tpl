
[app_cluster]
%{ for index, node in node_names ~}
${node} ansible_host=${node_ips[index]}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu

