
terraform {
  # No strong version requirements:
  required_version = ">= 1.0.0"

  required_providers {
    # No strong version requirements:
    aws = {
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Choose us-west-2 for AWS Lightsail (could use provider alias if want us-west-1 for EC2)
  # WARNING: you will need to choose an us-west-2 ami also in this case ...
  region = var.region
  #region = "us-west-2"
  #region = "us-west-1"

  default_tags {
    tags = {
      Owner       = "@mjbC"
    }
  }
}

