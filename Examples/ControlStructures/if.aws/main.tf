
variable is_internal_alb {
    default = false
}

resource "aws_route53_health_check" "service_up" {
    count = var.is_internal_alb ? 0 : 1

    type              = "HTTP"
}



