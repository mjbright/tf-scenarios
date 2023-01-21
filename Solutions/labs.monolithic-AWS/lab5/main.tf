
terraform {
  # Enforce Terraform version to be 1.0.x
  required_version = "~> 1.0"
  
  # Enforce AWS Provider version to be 3.0.x

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = var.region
}

