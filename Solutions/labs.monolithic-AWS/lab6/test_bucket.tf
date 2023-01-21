resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.unique_bucket_name}test"

  lifecycle { prevent_destroy = false }

  tags = {
      LabName = "6.StoringPersistentStates"
  }

  force_destroy = true 
}
