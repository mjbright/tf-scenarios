#!/usr/bin/env bash

# LOG stdout/stderr:
LOG=/tmp/init.sh.log
echo "Logging output to $LOG:"
exec > >(tee $LOG) 2>&1

HOSTNAME=$1; shift

# -- Change hostname
hostnamectl set-hostname $HOSTNAME

# -- Persist hostname, /etc//hosts values:
sed -i.bak -e 's/- update_/#- update/' /etc/cloud/cloud.cfg

# -- Allow password-less sudo for members of 'sudo' group:
sed 's/%sudo   ALL=(ALL:ALL) ALL/%sudo   ALL=(ALL:ALL) NOPASSWD:ALL/'
#apt-get install -y sudo

# -- Create user 'student'
NEW_USER=student
adduser -gecos "User ${NEW_USER}" ${NEW_USER} --disabled-password 2>&1 | tee /tmp/adduser.op

# -- Make user 'student' a member of sudo group
usermod -aG sudo ${NEW_USER}

# -- Allow same public key for 'student' login as the 'ubuntu' user
mkdir -p /home/${NEW_USER}/.ssh/
cp /home/ubuntu/.ssh/authorized_keys /home/${NEW_USER}/.ssh/
chown -R ${NEW_USER}:${NEW_USER} /home/${NEW_USER}
chmod 600 /home/${NEW_USER}/.ssh/authorized_keys

