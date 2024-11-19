output "instance_id" {
  description    = "ID of the EC2 instance"
  value          = aws_instance.tf-example-2.id
}

output "instance_public_ip" {
  description   = "Public IP address of EC2 instance"
  value       = aws_instance.tf-example-2.public_ip
}
