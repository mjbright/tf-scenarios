
# -------- Image definitions (will pull images):
resource "docker_image" "haproxy" {
  name = "haproxytech/haproxy-alpine"
  force_remove = false
}

resource "docker_image" "k8sdemo1" {
  name = "mjbright/k8s-demo:alpine1"
  force_remove = false
}
resource "docker_image" "k8sdemo2" {
  name = "mjbright/k8s-demo:alpine2"
  force_remove = false
}
resource "docker_image" "k8sdemo3" {
  name = "mjbright/k8s-demo:alpine3"
  force_remove = false
}
resource "docker_image" "k8sdemo4" {
  name = "mjbright/k8s-demo:alpine4"
  force_remove = false
}
resource "docker_image" "k8sdemo5" {
  name = "mjbright/k8s-demo:alpine5"
  force_remove = false
}
resource "docker_image" "k8sdemo6" {
  name = "mjbright/k8s-demo:alpine6"
  force_remove = false
}

# -------- Container definitions:

resource "docker_container" "lb" {
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
    source = "/home/student/labs/lab3b"
  }

  # Loop in case initial haproxy starts before container DNS entries are present:
  command = [ "/bin/sh", "-c", "while true; do haproxy -f /usr/local/etc/haproxy/haproxy.cfg; sleep 1; done" ]
}

resource "docker_container" "demo1" {
  image     = docker_image.k8sdemo1.image_id
  name      = "demo1"
  hostname  = "demo1"
  
  networks_advanced {
    name    = "apps"
    aliases = ["demo1"]
  }

  ports {
    internal = 80
    external = 8001
  }
}

resource "docker_container" "demo2" {
  image     = docker_image.k8sdemo2.image_id
  name      = "demo2"
  hostname  = "demo2"

  networks_advanced {
    name    = "apps"
    aliases = ["demo2"]
  }

  ports {
    internal = 80
    external = 8002
  }
}

resource "docker_container" "demo3" {
  image     = docker_image.k8sdemo3.image_id
  name      = "demo3"
  hostname  = "demo3"

  networks_advanced {
    name    = "apps"
        aliases = ["demo3"]
  }

  ports {
    internal = 80
    external = 8003
  }
}

resource "docker_container" "demo4" {
  image     = docker_image.k8sdemo4.image_id
  name      = "demo4"
  hostname  = "demo4"

  networks_advanced {
    name    = "apps"
    aliases = ["demo4"]
  }

  ports {
    internal = 80
    external = 8004
  }
}

resource "docker_container" "demo5" {
  image     = docker_image.k8sdemo5.image_id
  name      = "demo5"
  hostname  = "demo5"

  networks_advanced {
    name    = "apps"
    aliases = ["demo5"]
  }

  ports {
    internal = 80
    external = 8005
  }
}

resource "docker_container" "demo6" {
  image     = docker_image.k8sdemo6.image_id
  name      = "demo6"
  hostname  = "demo6"

  networks_advanced {
    name    = "apps"
    aliases = ["demo6"]
  }

  ports {
    internal = 80
    external = 8006
  }
}

