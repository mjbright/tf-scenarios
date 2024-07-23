
module be-servers {
    #source          = "../modules/be-container-servers"
    source          = "git::https://github.com/mjbright/terraform-modules.git//modules/be-container-servers?ref=7b7b3174cac5cb48db59bf13a7fd8be626ca7ce8"

    network_name    = var.be_network_name
    image_names     = var.image_names
    container_count = var.container_count
    base_ext_port   = var.base_port

    container_name_prefix = var.name_prefix
}

module fe-lb {
    #source          = "../modules/fe-container-lb"
    source          = "git::https://github.com/mjbright/terraform-modules.git//modules/fe-container-lb?ref=7b7b3174cac5cb48db59bf13a7fd8be626ca7ce8"

    # We need module.be-servers to complete as it creates the apps_network
    depends_on = [ module.be-servers ]

    network_name    = var.be_network_name
    container_name  = var.lb_name
    be_servers      = module.be-servers.c_ips

    ext_port           = var.lb_port
    ext_dashboard_port = var.ext_dashboard_port

    # Where generated haproxy.cfg should be placed:
    haproxy_cfg_abs_dir = "${ abspath( path.root ) }"
}

