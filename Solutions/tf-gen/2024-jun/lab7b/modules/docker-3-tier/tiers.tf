
resource docker_image tier1 {
    name  = var.tier1["image"]
}
resource docker_image tier2 {
    name  = var.tier2["image"]
}
resource docker_image tier3 {
    name  = var.tier3["image"]
}

resource docker_container tier1 {
    name  = var.tier1["name"]
    image = docker_image.tier1.image_id

    command = var.tier1["command"]

    networks_advanced {
        #name    = [ var.tier1["networks"][0] ]
        name    = local.networks[0]
        aliases = [ var.tier1["name"] ]
    }

    # Mount the tier1 load-balancer config directory from the local directory
    #   (but with absolute path):
    mounts {
        type   = "bind"
        target = var.tier1["config_target_dir"]
        source = abspath( var.tier1["config_source_dir"] )
      }

    ports {
        internal  = var.tier1["int_port"] == "" ? 80 : var.tier1["int_port"]
        external  = var.tier1["ext_port"]
    }
}

resource docker_container tier2 {
    count = var.tier2["count"]

    name  = format("%s-%d", var.tier2["name"], count.index)
    image = docker_image.tier2.image_id

    networks_advanced {
        #name    = [ var.tier2["networks"][0] ]
        name    = local.networks[0]
        aliases = [ format("%s-%d", var.tier2["name"], count.index) ]
    }

    ports {
        internal  = var.tier2["int_port"] == "" ? 80 : var.tier2["int_port"]
        external  = var.tier2["ext_port"]+count.index
    }
}

resource docker_container tier3 {
    name  = var.tier3["name"]
    image = docker_image.tier3.image_id

    networks_advanced {
        #name    = [ var.tier3["networks"][0] ]
        name    = local.networks[0]
        aliases = [ var.tier3["name"] ]
    }

    ports {
        internal  = var.tier3["int_port"] == "" ? 80 : var.tier3["int_port"]
        external  = var.tier3["ext_port"]
    }
}
