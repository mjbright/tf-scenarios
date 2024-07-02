
jumphost ansible_host=${jumphost_fip}

[app_cluster]
%{ for index, node in node_names ~}
${node} ansible_host=${node_ips[index]}
%{ endfor ~}

[app_cluster:vars]
ansible_ssh_common_args=' -o ProxyCommand="ssh -W %h:%p -q jumphost"'

[all:vars]
ansible_user=ubuntu

