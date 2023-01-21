
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}
