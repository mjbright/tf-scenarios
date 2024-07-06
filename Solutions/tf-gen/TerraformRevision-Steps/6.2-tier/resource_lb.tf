
resource "docker_image" "haproxy" {
  name = "haproxytech/haproxy-alpine"

  keep_locally = true
}

resource docker_container "lb" {
  image     = docker_image.haproxy.image_id
  name      = "lb"
  hostname  = "lb"

  networks_advanced {
    name    = "apps"
    aliases = ["lb"]
  }

  ports {
    internal = 80
    external = 8000
  }

  mounts {
    type = "bind"
    target = "/usr/local/etc/haproxy"
    source = "/home/student/labs/lab10"
  }

  # Loop in case initial haproxy starts before container DNS entries are present:
  command = [ "/bin/sh", "-c", "while true; do haproxy -f /usr/local/etc/haproxy/haproxy.cfg; sleep 1; done"
 ]
}
 
