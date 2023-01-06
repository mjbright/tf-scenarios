
#num_clusters = 10
#num_clusters = 1
num_clusters = 10

user = "ubuntu"

admin_private_key_file = "~/.ssh/strigo_nuaware_rsa"

# To be used by ansible:
user_private_key_file  = "~/.ssh/labs/lab43_ed25519"

user_intra_private_key_file = "~/.ssh/labs/intra_ed25519"

## zip_files         = ["../../FILES/LFD459-student.zip"]
## trainer_zip_files = [ "../../FILES/LFD459-trainer.zip" ]
zip_files = [ "../../../FILES/LFD459-student.zip" ]

user_data_file = "./scripts/user_data_setup.sh"

#TEMPLATE   = "TEMPLATE-ubuntu2004-4"
TEMPLATE    = "TEMPLATE-ubuntu2004-5-qemu-guest-agent"

cluster_prefix = "k8s"
node_names = [ "cp",  "worker" ]
node_state = [ "on",   "on" ]
node_disk  = [ "16G",  "16G" ]
node_mem   = [ "6144", "4096" ]
node_cores = [  4,     2 ]
node_roles = [ "cp" , "worker" ]
node_playbooks = {
    "cp":     [ "playbooks/playbook.yml", "playbooks/cp_k8s_playbook.yml",     "playbooks/on_off.yml" ],
    "worker": [ "playbooks/playbook.yml", "playbooks/worker_k8s_playbook.yml", "playbooks/on_off.yml" ],
}

# Enable auto install:
node_install_sh = {
    "cp":     [ "/home/student/scripts/k8s-installer.sh -CP", "kubectl get no" ],
    "worker": [ "/home/student/scripts/k8s-installer.sh -w", "ssh cp grep -A 1 -m 1 'kubeadm join' >/tmp/join.sh", "sh -x /tmp/join.sh", "sleep 10", "ssh cp kubectl get no" ],
}

vmid_base  = 20150

ip_prefix   = "192.168.0"
ip_base     = "150"
gw          = "192.168.0.254"

agent       = 1

