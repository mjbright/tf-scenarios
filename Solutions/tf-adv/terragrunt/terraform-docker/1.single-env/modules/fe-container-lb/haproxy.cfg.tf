
locals {
    haproxy_cfg = templatefile("${ path.module }/templates/haproxy.cfg.tpl", {
        be_servers = var.be_servers,
        port       = 80
    })
}

resource local_file haproxy_cfg {
    content = local.haproxy_cfg
    filename = "${ var.haproxy_cfg_abs_dir }/haproxy.cfg"
}

