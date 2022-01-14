
resource "aws_instance" "example" {
  count         = var.num_instances

  instance_type = "t2.micro"
  ami           = data.aws_ami.latest_ubuntu_lts_1804.id

  # Don't auto-recreate instance if new ami available:
  lifecycle {
    ignore_changes = [ami]
  }

  #depends_on = [ aws_key_pair.generated_key ]
  depends_on = [ local_file.key_local_file ]

  provisioner "local-exec" {
    # blocks completion of resource
    # command = "touch /tmp/ON_local_TF_HOST; hostname; echo 'This code executes on the local/Terraform host, the remote server IP address is ${self.public_ip}'; while ! curl -L http://${self.public_ip}:8080; do sleep 1; done" 
    command = "touch /tmp/ON_local_TF_HOST; hostname; echo 'This code executes on the local/Terraform host, the remote server IP address is ${self.public_ip}'"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_file)
    #host       = "${var.host}"
    host        = "${self.public_ip}"
  }

  provisioner "file" {
    #source     = "webserver.sh"
    content     = templatefile("templates/webserver.sh.tpl", {
      web_port  = var.ingress_ports["web"]
    })
    destination = "/tmp/webserver.sh"
  }

  provisioner "remote-exec" {
    inline      = [
      "touch /tmp/ON_remote_HOST; hostname; echo 'This code executes on the remote resource, (IP address is ${self.public_ip})'; chmod a+x /tmp/webserver.sh; sh -x /tmp/webserver.sh"
    ]
  }

  vpc_security_group_ids = [aws_security_group.secgroup-ssh.id] 

  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    LabName = "modules/provisioners demo"
  }

  ## cloud_init / user_data ---------------------------------------------------------
  # NOTE: cloud-init related output will be recorded in /var/log/syslog
  #       so to see the output (+more) from the below user_data:
  #           grep cloud-init /var/log/syslog

  #user_data = <<-EOF
  #EOF

  #user_data = file("${path.root}/provisioner.sh")

  #user_data = file( var.user_data_filepath )

  user_data = var.user_data_filepath == "" ? "" : file( var.user_data_filepath )
}

resource "random_id" "sec_group" {
  byte_length        = 6
}

resource "aws_security_group" "secgroup-ssh" {
  name        = "secgroup-${random_id.sec_group.id}"

  dynamic "ingress" {
    for_each = var.ingress_ports

    content {
      description = "Port ${ingress.key}: ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_ports

    content {
      description = "Port ${egress.key}: ${egress.value}"
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

