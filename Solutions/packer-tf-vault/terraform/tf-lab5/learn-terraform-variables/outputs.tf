output "public_dns_name" {
  description = "Public DNS names of the load balancer for this project"
  value       = module.elb_http.this_elb_dns_name
}

output "s3_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.remote_state.id
}

