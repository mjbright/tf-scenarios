
module "instances" {
    # Pulling from mjbright/terraform-modules:
    # - a sub-directory /modules/instances
    # - a specific commit (ref=sha256) 
    source        = "git::https://github.com/mjbright/terraform-modules.git//modules/instances?ref=af0bad34446e2534245c52f527d23d0de4392fdb"

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


