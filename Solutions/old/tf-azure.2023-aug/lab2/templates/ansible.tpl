
# https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters

[app_cluster]
%{ for index, node in node_names ~}
${node} ansible_host=${node_ips[index]} new_hostname=cp
%{ endfor ~}

[all:vars]
ansible_user=${user}
ansible_ssh_private_key_file=${key_file}

