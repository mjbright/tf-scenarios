
module "instances2" {
    source        = "./modules/instances"

    # input parameters:
    num_instances = 2
    ami_account   = local.canonical_account_number
    #key_pair      = ""
    key_file      = var.key_file
    user          = var.user
}


