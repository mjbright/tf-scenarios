
resource azurerm_resource_group rg {
    name     = var.resource_group
    location = var.location
}

module "azure-instances" {
    # https://www.terraform.io/language/modules/sources#selecting-a-revision
    #     Pulling from mjbright/terraform-modules:
    #     - a sub-directory /modules/instances
    #     - a specific commit (ref=sha256)
    # source        = "../../modules/azure-instances"
    # source        = "git::https://github.com/mjbright/terraform-modules.git//modules/azure-instances?ref=v0.8"
    source        = "git::https://github.com/mjbright/terraform-modules.git//modules/azure-instances?ref=cdfd6a9f066328fd9be3de0bc49f6b2bc0b8f3a8"
    
    location            = var.location
    resource_group      = var.resource_group

    depends_on = [azurerm_resource_group.rg]

    key_file          = var.key_file
    key_ppk_file      = var.key_ppk_file

    net_cidr            = var.net_cidr
    subnet_cidr         = var.subnet_cidr

    # user              = var.user
    admin_user          = var.user
    pub_ingress_ports = var.pub_ingress_ports

    # Remote-exec provisioner
    provisioner_templatefile = var.provisioner_templatefile

    dns_name          = var.host

    prefix            = var.prefix

    vm_size           = var.vm_size

    image_publisher   = var.image_publisher
    image_offer       = var.image_offer
    image_sku         = var.image_sku
    image_version     = var.image_version
}

