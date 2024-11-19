resource "aws_s3_bucket" "remote_state" {
    bucket = "remote-state-mjb"
    acl = "private"
    force_destroy = true
    
    tags = {
        Name = "remote state backend"
    }
}
