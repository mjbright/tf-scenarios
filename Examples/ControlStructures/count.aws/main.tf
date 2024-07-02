
variable vpc_cidr {
    default = "192.168.0.0/16"
}

variable vpc_subnet_cidr {
    default = [ "192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24" ]
}

resource "aws_vpc" "main-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "vpc_subnets" {
    # lines removed …
    count = length(var.vpc_subnet_cidr)

    vpc_id = aws_vpc.main-vpc.id
    cidr_block = element(var.vpc_subnet_cidr,   count.index)
    tags = {
        Name = "subnet-${count.index+1}"
    }
}


