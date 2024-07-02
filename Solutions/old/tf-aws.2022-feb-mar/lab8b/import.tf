resource "aws_instance" "imported_item" {
    ami           = "ami-0e42deec9aa2c90ce"
    instance_type = "t2.micro"
}
