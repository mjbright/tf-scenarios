
provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "remote_state" {
  bucket = var.unique_bucket_name

  # Removed in hashicorp/aws version 4.0.0: now use aws_s3_bucket_acl if needed:
  # acl    = "private"

  # Removed in hashicorp/aws version 4.0.0: now use aws_s3_bucket_versioning if needed:
  # versioning {    enabled = true  }

  lifecycle { prevent_destroy = false }
  
  tags = {
      LabName = "6.StoringPersistentStates"
  }

  # All objects to be deleted from bucket to allow bucket deletion without error
  force_destroy = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = var.dynamodb_lock_table_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID" 

  tags = {
      LabName = "6.StoringPersistentStates"
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}

