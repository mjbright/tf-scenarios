
resource "aws_security_group" "alb" {
  name_prefix = "tfi-lab9-alb"
}

resource "aws_security_group_rule" "alb_allow_http_inbound" {
  type              = "ingress"
  
  # CHANGED to web_server_http_port:
  from_port         = var.alb_http_port
  to_port           = var.alb_http_port
  
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}
