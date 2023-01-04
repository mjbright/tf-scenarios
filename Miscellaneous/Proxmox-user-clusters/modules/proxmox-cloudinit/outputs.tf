
output "instances"        { value = proxmox_vm_qemu.proxmox_vm.* }

output "ansible_hosts"    { value = local_file.ansible_hosts }

