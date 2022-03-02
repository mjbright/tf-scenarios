
resource "aws_instance" "example" {
  ami           = "ami-0e81aa4c57820bb57"
  instance_type = "t2.micro"

  tags = {
    LabName = "1.InstallTerraform"
  }
}


