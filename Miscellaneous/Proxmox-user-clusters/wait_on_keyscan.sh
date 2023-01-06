#!/bin/bash

# ./wait_on_keyscan.sh ${self.default_ipv4_address} ${local.node_fqdns[count.index]} ${var.cluster_prefix} ${count.index}

IP4=$1; shift
FQDN=$1; shift
CLUSTER_PREFIX=$1; shift
NODE_IDX=$1; shift

mkdir -p var

[ -f ~/.ssh/known_hosts ] && {
          set -x
          ssh-keygen -f ~/.ssh/known_hosts -R $IP4
          ssh-keygen -f ~/.ssh/known_hosts -R $FQDN
          set +x
} > var/ssh.keygen.${CLUSTER_PREFIX}-${NODE_IDX}.op 2>&1

OP=var/ssh.keyscan.${CLUSTER_PREFIX}-${NODE_IDX}.op
ERR=var/ssh.keyscan.${CLUSTER_PREFIX}-${NODE_IDX}.err
LOOP=var/ssh.keyscan.${CLUSTER_PREFIX}-${NODE_IDX}.loop

touch $OP
OP_LOOP=0
while [ ! -s $OP ]; do
    let OP_LOOP=OP_LOOP+1
    echo "$OP_LOOP" > $LOOP
    set -x
        ssh-keyscan $IP4
        ssh-keyscan $FQDN
        #ssh-keyscan -t rsa $IP4
        #ssh-keyscan -t rsa $FQDN
    set +x
    sleep 10
done > $OP 2>$ERR

wc -l $OP
cat $OP>> ~/.ssh/known_hosts

