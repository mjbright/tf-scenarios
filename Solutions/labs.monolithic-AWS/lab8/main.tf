
resource "aws_instance" "web_server" {
  count         = length(var.names)
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_server.id]

  user_data = <<-EOF
              #!/bin/bash
              echo ${var.server_text} > /tmp/index.html
              cd /tmp/
              nohup busybox httpd -f -p ${var.http_port} &
              EOF

  tags = {
    Name = element(var.names, count.index)
  }
}

