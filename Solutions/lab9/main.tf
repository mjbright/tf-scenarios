resource "aws_autoscaling_group" "web_servers" {
  # Note that we intentionally depend on the Launch Configuration name so that creating a new Launch Configuration
  # (e.g. to deploy a new AMI) creates a new Auto Scaling Group. This will allow for rolling deployments.
  name = aws_launch_configuration.web_servers.name

  launch_configuration = aws_launch_configuration.web_servers.name

  min_size         = 3
  max_size         = 3
  desired_capacity = 3
  min_elb_capacity = 3

  # Deploy all the subnets (and therefore AZs) available
  vpc_zone_identifier = data.aws_subnets.default.ids

  # Automatically register this ASG's Instances in the ALB and use the ALB's health check to determine when an Instance
  # needs to be replaced
  health_check_type = "ELB"

  target_group_arns = [aws_alb_target_group.web_servers.arn]

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
  # To support rolling deployments, we tell Terraform to create a new ASG before deleting the old one. Note: as
  # soon as you set create_before_destroy = true in one resource, you must also set it in every resource that it
  # depends on, or you'll get an error about cyclic dependencies (especially when removing resources).
  lifecycle {
    create_before_destroy = true
  }

  # This needs to be here to ensure the ALB has at least one listener rule before the ASG is created. Otherwise, on the
  # very first deployment, the ALB won't bother doing any health checks, which means min_elb_capacity will not be
  # achieved, and the whole deployment will fail.
  depends_on = [aws_alb_listener.http]
}


resource "aws_launch_configuration" "web_servers" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name        = var.key_name
  security_groups = [aws_security_group.web_server.id]

  # To keep this example simple, we run a web server as a User Data script. In real-world usage, you would typically
  # install the web server and its dependencies in the AMI.
  user_data = <<-EOF
              #!/bin/bash
              echo "from $(hostname): ${var.server_text}" > index.html
              nohup busybox httpd -f -p "${var.web_server_http_port}" &
              EOF

  # When used with an aws_autoscaling_group resource, the aws_launch_configuration must set create_before_destroy to
  # true. Note: as soon as you set create_before_destroy = true in one resource, you must also set it in every resource
  # that it depends on, or you'll get an error about cyclic dependencies (especially when removing resources).
  lifecycle {
    create_before_destroy = true
  }
}

