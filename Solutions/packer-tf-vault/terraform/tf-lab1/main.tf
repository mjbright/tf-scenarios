terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "tf-example" {
  # us-west-2:
  # ami           = "ami-830c94e3"

  # us-west-1:
  ami           = "ami-03420c5d8fd979bd3"
  instance_type = "t2.micro"

  tags = {
    Name = "TF-example"
  }
}
