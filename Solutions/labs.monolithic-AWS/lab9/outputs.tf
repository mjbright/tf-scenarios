
# Create an output to show the curl command to access the ALB:

output alb_curl_dns {
    value = [ for dns in aws_alb.web_servers.*.dns_name :
        "curl -L http://${dns}:${var.alb_http_port}"
    ]
}

