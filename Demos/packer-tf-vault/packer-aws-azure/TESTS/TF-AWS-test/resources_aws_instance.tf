
resource aws_instance testvm {
  # Use instance_profile if provided:
  #iam_instance_profile = (
      #length(var.iam_instance_profiles) > 0 ? element( var.iam_instance_profiles, count.index ) : ""
  #)
  instance_type = var.instance_type

  # Lookup latest image for var.ami_family, else local.default_ami_family:
  ami = var.ami

  depends_on = [ aws_key_pair.provided_key ]

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  provisioner local-exec {
    # blocks completion of resource
    command = "touch /tmp/.local-exec; hostname; echo 'Remote server IP address is ${self.public_ip}'"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file( local.key_file )
    #host       = var.host
    host        = self.public_ip
  }
   
  vpc_security_group_ids = [ aws_security_group.secgroup-ssh.id ]

  key_name               = aws_key_pair.provided_key.key_name

  tags = merge( var.tags, {
        Module = "aws-instances",
    },
  )

  ## cloud_init / user_data ---------------------------------------------------------
  # user_data = var.user_data_file == "" ? "" : file( var.user_data_file )
}

#resource random_id sec_group {
  #byte_length = 6
#}

resource aws_security_group secgroup-ssh {
  #name        = "secgroup-${random_id.sec_group.id}"
  name        = "secgroup-packer-test"

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

