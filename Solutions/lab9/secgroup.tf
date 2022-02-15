
resource "aws_security_group" "web_server" {
  name_prefix = "tfi-lab9"
}

resource "aws_security_group_rule" "web_server_allow_http_inbound" {
  type              = "ingress"
  
  # CHANGED to web_server_http_port:
  from_port         = var.web_server_http_port
  to_port           = var.web_server_http_port
  
  protocol          = "tcp"
  security_group_id = aws_security_group.web_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_server_allow_ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.web_server.id

  # Should be more restrictive in production:
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_server_allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

