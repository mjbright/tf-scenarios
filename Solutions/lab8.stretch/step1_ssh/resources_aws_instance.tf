
resource "aws_instance" "example" {
  instance_type = "t2.micro"

  ami           = data.aws_ami.latest_ubuntu_lts_1804.id
  # Don't auto-recreate instance if new ami available:
  lifecycle {
    ignore_changes = [ami]
  }

  vpc_security_group_ids = [aws_security_group.secgroup-ssh.id] 

  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    LabName = "provisioners - step 1"
  }
}

resource "random_id" "sec_group" {
  byte_length        = 6
}

resource "aws_security_group" "secgroup-ssh" {
  name = "secgroup-${random_id.sec_group.id}"

  # Enable incoming ssh connection:
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


