#!/bin/bash
#!/bin/bash -e

LOG=/tmp/setup.sh.log
ZIP=/tmp/files1.zip

echo "[$(date)] $0 $*"  >> $LOG

shopt -s expand_aliases
alias apt-get='apt-get -o DPkg::Lock::Timeout=60'

## -- Functions: ------------------------------------------------
LOG() {
    echo "$(date): $*" |& tee -a /tmp/.remote-exec_setup.log
}

die() {
    LOG "$0: die - $*"
    echo "$0: die - $*" >&2
    exit 1;
}

warn() {
    echo "$0: warn - $*"
    echo "... continuing"
    return 0
}

ADD_KEYS() {
    P_USER=$1; shift

    sudo mkdir -p /home/$P_USER/.ssh
    sudo chmod 700 /home/$P_USER/.ssh

    sudo tee -a /home/$P_USER/.ssh/authorized_keys
    sudo chmod 600 /home/$P_USER/.ssh/authorized_keys
    sudo chown -R $P_USER:$P_USER /home/$P_USER/
    sudo ls -alR /home/$P_USER/.ssh
}

UNZIP_FILE() {
    cd /
    echo "-- Files before unzip: -----------------------------------------"
    find home/student/

    for zip in $*; do
        ls -altrh $zip
        echo "-- sudo unzip -o $zip"
        sudo unzip -o $zip
    done

    echo "-- Files after unzip: ------------------------------------------"
    find home/student/
}

## -- Main: -----------------------------------------------------

LOG "==== SCRIPT $0 $* (SHELL=$SHELL USER=$(id -un))"

[ "$(id -un)" != "ubuntu" ] && {
    sudo useradd --shell /bin/bash ubuntu
    #sudo usermod -aG docker ubuntu
    sudo usermod -aG sudo   ubuntu
}

curl -s ifconfig.me
echo
IP=$( curl -s ifconfig.me )
#?? "echo ssh -i \~/.ssh/packer_ed25519 ubuntu@$IP uptime
ip a
hostname
LOG ==== STEP adding packer pub key to /home/ubuntu/.ssh/authorized_keys
id
pwd
ls -altr

echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOALv17JIFBFTjpNfTdgCQsz3jz3DVS/u77NqRIp2Bnq packer_ed25519 |
    ADD_KEYS ubuntu
echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOALv17JIFBFTjpNfTdgCQsz3jz3DVS/u77NqRIp2Bnq packer_ed25519 |
    ADD_KEYS packer

LOG ==== STEP useradd --shell /bin/bash student
sudo useradd --shell /bin/bash student

LOG ==== STEP installing zip/unzip packages
sudo apt-get update || warn "apt-get update failed"
env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y zip unzip || warn "apt-get install zip failed"

# NOT IN AZURE CASE !!  As user ubuntu: so no need for sudo:
id -un
LOG ==== STEP adding pub keys to /home/ubuntu/.ssh/authorized_keys
#ls -ald /home/ubuntu/.ssh
#mkdir -p /home/ubuntu/.ssh
#ls -ald /home/ubuntu/.ssh
#set -x; ls -ald /home/ubuntu/.ssh
# ALREADY PRESENT: (from initial_setup.sh)
#echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOALv17JIFBFTjpNfTdgCQsz3jz3DVS/u77NqRIp2Bnq packer_ed25519 | sudo tee -a /home/ubuntu/.ssh/authorized_keys
echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINh6JDlyltuFEBdcJcRGGqUDtX+Ki9scQS8pQ86uda8h lab43_admin_ed25519.pub |
    ADD_KEYS ubuntu
      # WHY DOES THIS PRODUCE AN ERROR?:
          #"chown -R ubuntu:ubuntu /home/ubuntu/.ssh
# sudo chown -R ubuntu:ubuntu /home/ubuntu/
#sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh

LOG ==== STEP installing packages ...
sudo apt-get update || warn "apt-get update failed"
sudo apt-get upgrade -y || warn "apt-get upgrade failed"

LOG "-- PACKAGES=$PACKAGES"
#env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' ${ PACKAGES } || warn "apt-get install failed"
env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' $PACKAGES || warn "apt-get install failed"
#env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' ${ var.apt_packages } || warn "apt-get install failed"
      #"sudo apt -y autoremove --purge
      #"sudo apt -y clean
      #"sudo apt -y autoclean

LOG ==== STEP unpacking /tmp/files1.zip
echo ZIP=$ZIP >> $LOG
echo UNZIP_FILE $ZIP >> $LOG
UNZIP_FILE $ZIP

LOG ==== STEP adding pub keys to /home/student/.ssh/authorized_keys
      # As user ubuntu: so need sudo:
sudo mkdir -p /home/student/.ssh

cat <<EOF | ADD_KEYS student
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSgp20nvALXpqmIwsE5wFnz2OxNklJ63XspuVU9Mi6S mjb@NUC3
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4wIy1lPBmroRf55us5UC1KXSd60cEYOfszRQeVq3Vr mjb@NUC3_intra_ed25519
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVoZalzKAoOszNA7uAV0kLdTZDXNuJuMhyfCJi2tMsZ lab43_ed25519.pub
EOF

#sudo chown -R student:student /home/student/.ssh

LOG ==== STEP Adding {ubuntu,student} to docker group
      # Assuming docker already in base image:
sudo usermod -aG docker ubuntu
sudo usermod -aG docker student

LOG ==== STEP Modifying /etc/sudoers
sudo sed -i.bak 's/^%sudo.*/%sudo   ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

LOG ==== STEP sync - ready for powerdown
sudo sync

LOG "DONE $0 $*"
#echo "[$(date)] DONE $0 $*"  | tee -a $LOG

exit 0

