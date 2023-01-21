
provider "aws" {
    region = var.region
}

variable "region" {
    description = "the AWS region to use"
}

variable ami_instance {
    default = "unset"
}

module "latest-ubuntu-ami" {
    # Reference module latest-ubuntu-ami in github repo github.com/mjbright/terraform-modules
    # NOTE: double-slash to reference subdirectory of the repo:  //modules/latest-ubuntu-ami
    source = "github.com/mjbright/terraform-modules//modules/latest-ubuntu-ami"
    
    # translates to:
    #   git::https://github.com/mjbright/terraform-modules.git
    # To verify try:
    #     rm -rf /home/student/dot.terraform/modules
    #     TF_LOG=trace terraform init |& grep fetch
    
    region = var.region
}

resource "aws_instance" "example" {
    ami = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS

    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.secgroup-user10.id]
}

resource "aws_security_group" "secgroup-user10" {
    name = "simple security group - user10"

    # Enable incoming ssh connection:
    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output ami_instance {
  value = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS
}

