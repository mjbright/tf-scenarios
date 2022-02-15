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

resource "local_file" "pem_key" {
  filename        = "key.pem"
  content         = tls_private_key.mykey.private_key_pem
  file_permission = 0600
}

