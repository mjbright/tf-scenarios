
provider "aws" {
  region = var.region
}

variable "region" {
  description = "The region to use"
  default="us-west-1"
}

# NOTE: The AWS 'key pair' is the public/private key pair which
#       can be used to enable connectivity to EC2 instances
variable "key_name" {
  description = "The name of the AWS 'key pair' to create"
  default     = "my_key"
}

# An aws_instance is an 'AWS EC2' resource: a virtual machine
# In our config we can refer to this instance as:
#     aws_instance.example
resource "aws_instance" "example" {
  ami = lookup(var.ami_instance, var.region)
  #ami = "ami-0e81aa4c57820bb57"
  instance_type = "t2.micro"

  tags     = { LabName = "2.Workflow" }
  vpc_security_group_ids = [aws_security_group.secgroup-ssh.id]
  key_name = aws_key_pair.generated_key.key_name
}

# Create a TLS private key  resource
resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS 'key pair' resource usable for ssh from the TLS private key
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.mykey.public_key_openssh
}


output "ssh_rsa_pub_key" { value = tls_private_key.mykey.public_key_openssh }

output "ssh_pem_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

output "public_ip" { value = aws_instance.example.public_ip }

resource "local_file" "pem_key" {
  filename        = "key.pem"
  content         = tls_private_key.mykey.private_key_pem
  file_permission = 0600
}


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
