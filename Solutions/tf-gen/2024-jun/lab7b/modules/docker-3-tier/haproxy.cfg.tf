
locals {
    middle_servers = [ for i in range( var.tier2["count"] ) : format("%s-%d", var.tier2["name"], i) ]

    haproxy_cfg = templatefile("${ path.module }/haproxy.cfg.tpl", {
        middle_servers = local.middle_servers
    })


}

resource local_file haproxy_cfg {
    content = local.haproxy_cfg
    filename = "${ path.root }/haproxy.cfg"
}
