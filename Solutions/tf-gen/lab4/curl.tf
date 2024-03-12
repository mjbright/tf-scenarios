

locals {
    curl_script = templatefile("${path.module}/curl.tpl", {
       containers = docker_container.test1.*
    }
    )
}


resource "local_file" "curl_script" {
    content   = local.curl_script
    filename  = "curl.sh"
}


