variable "ami_instance" {
  description = "A mapping from AWS region to Amazon Machine Image"
  type        = map(string)

  default = {
    "eu-north-1"     = "ami-0567220a328fe4fee"
    "ap-south-1"     = "ami-0237472cf337d9529"
    "eu-west-3"      = "ami-0df03c7641cf41947"
    "eu-west-2"      = "ami-00f94dc949fea2adf"
    "eu-west-1"      = "ami-0e41581acd7dedd99"
    "ap-northeast-2" = "ami-0f4362c71ffaf7759"
    "ap-northeast-1" = "ami-0d5db3e2a1b98ca94"
    "sa-east-1"      = "ami-0065a65613972a22a"
    "ca-central-1"   = "ami-0dbe45195223e250b"
    "ap-southeast-1" = "ami-0c199cae95cea87f0"
    "ap-southeast-2" = "ami-0c0483bc96aef8b2f"
    "eu-central-1"   = "ami-040a1551f9c9d11ad"
    "us-east-1"      = "ami-0d5ae5525eb033d0a"
    "us-east-2"      = "ami-0a7f2b5b6b87eaa1b"
    "us-west-1"      = "ami-00a3e4424e9ab3e56"
    "us-west-2"      = "ami-09c6723c6c24250c9"
  }
}
