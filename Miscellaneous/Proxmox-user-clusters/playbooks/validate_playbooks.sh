#!/bin/bash

die() {
    echo "$0: warn - $*" >&2; 
    ERR_PLAYBOOKS+=" $PLAYBOOK"
}

ERR_PLAYBOOKS=""

VALIDATE_PLAYBOOK() {
    PLAYBOOK=$1; shift
    OTHER=$*

    set -x
        ansible-playbook -i var/ansible_hosts.k8s0 $OTHER --check $PLAYBOOK || die "errors in playbook $PLAYBOOK"
    set +x
}

#ansible-playbook -i var/ansible_hosts.k8s0 --check playbooks/playbook.yml
#ansible-playbook -i var/ansible_hosts.k8s0 --limit group_cp     --check playbooks/cp_k8s_playbook.yml  
#ansible-playbook -i var/ansible_hosts.k8s0 --limit group_worker --check playbooks/worker_k8s_playbook.yml 
#ansible-playbook -i var/ansible_hosts.k8s0 --check playbooks/on_off.yml 

VALIDATE_PLAYBOOK playbooks/playbook.yml
VALIDATE_PLAYBOOK playbooks/cp_k8s_playbook.yml     --limit group_cp
VALIDATE_PLAYBOOK playbooks/worker_k8s_playbook.yml --limit group_worker
VALIDATE_PLAYBOOK playbooks/on_off.yml 

[ ! -z "$ERR_PLAYBOOKS" ] && echo "Errors seen in: $ERR_PLAYBOOKS"
[   -z "$ERR_PLAYBOOKS" ] && echo "NO errors seen in playbooks"

