
locals {
    haproxy_cfg = templatefile("tpl/haproxy.cfg.tpl", {
        containers = var.containers
    })

    report_op   = templatefile("tpl/report.tpl", {
        lb_image   = docker_image.haproxy.name,
        containers = var.containers,
        resources  = docker_container.server
    })
}

resource local_file haproxy-cfg {
    filename = "./haproxy.cfg"
    content  = local.haproxy_cfg
}

resource local_file report-op {
    filename = "./report.op"
    content  = local.report_op
}

