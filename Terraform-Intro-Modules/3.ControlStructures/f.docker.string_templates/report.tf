
locals {
    report_info = templatefile( "tpl/report.tpl", {
        vms      = var.vms,
        vm_infos = docker_container.test,
    })
}

resource local_file report_info {
    filename = "./results.txt"
    content  = local.report_info
}



