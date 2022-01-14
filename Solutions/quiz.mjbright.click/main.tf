
module "instances" {
    source        = "./modules/instances"

    # input parameters:
    num_instances = 1
    ami_account   = local.canonical_account_number
    #key_pair      = ""
    key_file      = var.key_file
    user          = var.user
    ingress_ports = var.ingress_ports
    egress_ports  = var.egress_ports

    # User data provisioning:
    user_data_filepath = var.user_data_filepath

    # DNS Domain parameters:
    domain  = var.domain
    zone_id = var.zone_id
}


