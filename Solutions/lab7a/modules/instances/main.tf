
module "vpc_module" {
    source = "../vpc"
    
    region = var.region
}

resource "aws_instance" "webserver" {
    count         = length(module.vpc_module.aaz)

    ami           = lookup(  var.ami_instance,var.region )
    subnet_id     = element( module.vpc_module.subnet_ids, count.index )
    instance_type = var.ami_instance_type
}

