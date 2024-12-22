
terraform {
    required_version = ">= 1.8.0"

    required_providers {
        aws = {
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.region

    default_tags {
        tags = {
              Environment = "Terraform Introduction"
        }
    }
}

