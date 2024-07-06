
data docker_image lb {
  name = "haproxytech/haproxy-alpine"
}

data docker_network default {
  name = "bridge"
}

data local_file vars {
  filename = "${path.module}/terraform.tfvars"
}

output images {
    value = format("%s: digest:%s ", data.docker_image.lb.name, data.docker_image.lb.repo_digest )
}

output networks {
    value = format("%s: driver:%s ipam_config:%v",
               data.docker_network.default.name,
               data.docker_network.default.driver,
               data.docker_network.default.ipam_config )
}

output vars {
    value = format("File: terraform.tfvars:\n\nFile Content:%s\n\nMD5sum:%s\n\n",
        data.local_file.vars.content,
        data.local_file.vars.content_md5)
}
