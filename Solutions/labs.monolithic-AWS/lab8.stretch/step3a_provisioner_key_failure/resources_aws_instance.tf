
locals {
  ports = {
    "ssh": 22, # Enable incoming ssh connection:
    "web": 8080  # Enable incoming web connection:
  }
}


resource "aws_instance" "example" {
  instance_type = "t2.micro"

  ami           = data.aws_ami.latest_ubuntu_lts_1804.id
  # Don't auto-recreate instance if new ami available:
  lifecycle {
    ignore_changes = [ami]
  }

  provisioner "local-exec" {
    # blocks completion of resource
    # command = "touch /tmp/ON_local_TF_HOST; hostname; echo 'This code executes on the local/Terraform host, the remote server IP address is ${self.public_ip}'; while ! curl -L http://${self.public_ip}:8080; do sleep 1; done" 
    command = "touch /tmp/ON_local_TF_HOST; hostname; echo 'This code executes on the local/Terraform host, the remote server IP address is ${self.public_ip}'"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.key_file)
    #host     = "${var.host}"
    host     = "${self.public_ip}"
  }

  provisioner "file" {
    #source      = "webserver.sh"
    content = templatefile("templates/webserver.sh.tpl", {
      web_port = local.ports["web"]
    })
    destination = "/tmp/webserver.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "touch /tmp/ON_remote_HOST; hostname; echo 'This code executes on the remote resource, (IP address is ${self.public_ip})'; chmod a+x /tmp/webserver.sh; sh -x /tmp/webserver.sh"
    ]
  }

  user_data = <<-EOF
    #!/bin/bash

    echo "THIS IS MY USER DATA SPEAKING!!"
EOF


  vpc_security_group_ids = [aws_security_group.secgroup-ssh.id] 

  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    LabName = "provisioners - step 3"
  }
}

resource "random_id" "sec_group" {
  byte_length        = 6
}

resource "aws_security_group" "secgroup-ssh" {
  name        = "secgroup-${random_id.sec_group.id}"

  dynamic "ingress" {
    for_each = local.ports
    content {
      description = "Port ${ingress.key}: ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

