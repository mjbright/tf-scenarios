
provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0e81aa4c57820bb57"
  instance_type = "t2.micro"

  tags = { LabName = "1.InstallTerraform" }
}

output  "public_ip"     { value = aws_instance.example.public_ip }

