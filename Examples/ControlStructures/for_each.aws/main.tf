
variable vpc_cidr {
    default = "192.168.0.0/16"
}

variable vpc_subnet_cidr {
    type    = list(string)
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
    for_each = toset(var.vpc_subnet_cidr)

    vpc_id = aws_vpc.main-vpc.id
    cidr_block = each.value
    tags = {
        Name = "subnet-${ index(var.vpc_subnet_cidr, each.value) }"
        # val = each.value
        # key = each.key (same as each.value)
    }
}


