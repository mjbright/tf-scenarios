
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

  vpc_security_group_ids = [aws_security_group.secgroup-ssh.id] 

  key_name      = aws_key_pair.generated_key.key_name


  # user_data can be accessed thus, from within the instance:
  #     curl -sL http://169.254.169.254/latest/user-data
  # user_data can be deleted thus, from outside the instance:
  #     aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"
  user_data = templatefile("templates/webserver.sh.tpl", {
      web_port = local.ports["web"]
    }
  )

  tags = {
    LabName = "provisioners - step 2b"
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

