provider "aws" {
    region = "us-west-1"
}

variable "key_name" {
    default = "my_key"
}

resource "aws_instance" "example" {
    ami = "ami-0e81aa4c57820bb57"
    instance_type = "t2.micro"

    vpc_security_group_ids = [aws_security_group.secgroup-ssh.id] 

    key_name      = aws_key_pair.generated_key.key_name

    tags = {
        LabName = "1b.ConnectToYourVM"
        Name = "HelloWorld"
    }
}

resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.mykey.public_key_openssh
}


resource "aws_security_group" "secgroup-ssh" {
  name = "security group - for ssh Ingress only"
  # Enable incoming ssh connection:
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output  "public_ip"       { value = aws_instance.example.public_ip }
output  "ssh_rsa_pub_key" { value = tls_private_key.mykey.public_key_openssh }
output  "ssh_pem_key"     {
  value = tls_private_key.mykey.private_key_pem
  sensitive = true
}

