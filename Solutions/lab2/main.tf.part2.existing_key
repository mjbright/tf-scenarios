
provider "aws" {
    region = var.region
}

variable "region" {
    description = "The region to use"
    default="us-west-1"
}

variable "key_name" {
    default = "my_rsa_key"
}

resource "aws_instance" "example" {
    ami = lookup(var.ami_instance,var.region)
    #ami = "ami-0e81aa4c57820bb57"
    instance_type = "t2.micro"

    tags = { LabName = "2.Workflow" }
    vpc_security_group_ids = [aws_security_group.secgroup-ssh.id]
    key_name      = aws_key_pair.generated_key.key_name
}

resource "aws_key_pair" "generated_key" {
    key_name   = var.key_name
    public_key = file("~/.ssh/id_rsa.pub")
}

output  "public_ip"       { value = aws_instance.example.public_ip }

resource "aws_security_group" "secgroup-ssh" {
  name = "simple security group - for ssh Ingress only"

  # Enable incoming ssh connection:
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output  "private_ip"    { value = aws_instance.example.private_ip }
output  "public_dns"    { value = aws_instance.example.public_dns }

