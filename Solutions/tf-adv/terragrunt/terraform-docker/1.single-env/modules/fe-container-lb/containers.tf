
# -------- Image definitions (will pull images):
resource "docker_image" "haproxy" {
  name = "haproxytech/haproxy-alpine"

  keep_locally = true
}

# -------- Container definitions:

resource "docker_container" "lb" {
  image     = docker_image.haproxy.image_id
  name      = "lb"
  hostname  = "lb"

  # Wait for haproxy.cfg to be created before creating this container:
  depends_on = [ local_file.haproxy_cfg ]

  networks_advanced {
    name    = var.network_name
    aliases = ["lb"]
  }

  # Expose load-balanced be-servers:
  ports {
    internal = 80
    external = var.ext_port
  }

  # Expose haproxy dashboard:
  ports {
    internal = 8404
    external = var.ext_dashboard_port
  }

  mounts {
    type = "bind"
    target = "/usr/local/etc/haproxy"
    source = var.haproxy_cfg_abs_dir
  }

  # Loop in case initial haproxy starts before container DNS entries are present:
  command = [ "/bin/sh", "-c", "while true; do haproxy -f /usr/local/etc/haproxy/haproxy.cfg; sleep 1; done" ]
}

