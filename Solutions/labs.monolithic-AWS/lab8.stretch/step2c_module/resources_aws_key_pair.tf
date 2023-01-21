
resource "random_id" "key_pair" {
  byte_length      = 6
}

resource "tls_private_key" "tmpkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "auto-keypair-${random_id.key_pair.id}"
  public_key = tls_private_key.tmpkey.public_key_openssh
}

# File to save .pem key to:
resource "local_file" "key_local_file" {
  content         = tls_private_key.tmpkey.private_key_pem
  filename        = var.key_file
  file_permission = 0600
}


