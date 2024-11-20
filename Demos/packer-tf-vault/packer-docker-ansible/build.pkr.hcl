
build {
  sources = [ "source.docker.ubuntu" ]

  ## == INSTALL Ansible on local host and in container: =========================

  # LOCAL:
  provisioner "shell-local" {
    environment_vars = [
        "DEBIAN_FRONTEND=noninteractive"
    ]

    # script = "provisioner-scripts/ansible-setup.sh"
    inline = [
      "bash -c 'dpkg -l | grep ansible-core || { echo INSTALLING ANSIBLE on localhost; apt-get update; apt-get install -y ansible; }'"
    ]
  }

  # CONTAINER:
  provisioner "shell" {
    environment_vars = [
        "DEBIAN_FRONTEND=noninteractive"
    ]

    # script = "provisioner-scripts/ansible-setup.sh"
    inline = [
        "echo 'INSTALLING ANSIBLE & SUDO in container'",
        "set -x",
        "apt-get update",
        "apt-get install -y ansible sudo 2>&1 | grep 'newly installed'"
     ]
  }

  ## == INVOKE  Ansible in container: ===========================================
  #provisioner "file" {
  #  sources     = [ "provisioner-playbooks/apache.yaml" ]
  #  destination = "playbooks/apache.yaml"
  #}

  provisioner "ansible" {
      #  #extra_arguments = ["--scp-extra-args", "'-O'", "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"]
     # TO work around OpenSSH/9.0 adoption of sftp in place of scp:
     extra_arguments = [ "--scp-extra-args", "'-O'" ]

     playbook_file   = "provisioner-playbooks/apache.yaml"
     #user            = "ubuntu"
     user            = "ansible"
  }

  #provisioner "file" {
  #  sources     = [ pathexpand( "~/tmp/IT.SETUP/LFD459-student.zip" ) ]
  #  destination = "/tmp/files1.zip"
  #}

  ## To allow debugging: allow early ssh access (to test!) - looks like ssh is blocked ...
  #provisioner "shell" {
  #  environment_vars = [
  #      "PACKAGES=${ var.apt_packages }"
  #  ]
  #  script     = "provisioner-scripts/setup.sh"
  #}
}

