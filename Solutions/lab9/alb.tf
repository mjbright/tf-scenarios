
resource "aws_alb" "web_servers" {
  name            = var.name
  security_groups = [aws_security_group.alb.id]
  subnets         = data.aws_subnets.default.ids

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.web_servers.arn
  port              = var.alb_http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web_servers.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "web_servers" {
  name     = var.name
  port     = var.web_server_http_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  deregistration_delay = 10

  health_check {
    path                = "/"
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener_rule" "send_all_to_web_servers" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web_servers.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

# Attach this to the default VPC which we're using:

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [ data.aws_vpc.default.id ]
  }
}

