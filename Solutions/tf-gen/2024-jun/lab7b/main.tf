
variable network {
    default = "ntier-app-net"
}

module ntier {
    # Use module source in local ./modules sub-directory:
    source = "github.com/mjbright/terraform-modules//modules/docker-3-tier?ref=d7f3e391ab373f9eb900f1c17c5b4f2182578256"

    tier1 = {
        # 1 load-balancer instance:
        "name": "lb",
        "image": "haproxytech/haproxy-alpine"
        "networks": [ var.network ]
        "int_port": 80,
        "ext_port": 8000,
        "config_target_dir": "/usr/local/etc/haproxy",
        "config_source_dir": "." # Relative to root module directory
        "command":           [ "/bin/sh", "-c", "while true; do haproxy -f /usr/local/etc/haproxy/haproxy.cfg; sleep 2; done" ]
    }
    tier2 = {
        # multiple-instances of middleware
        "count": 6,

        "name": "flask-fe",
        "image": "mjbright/flask-web:v1"
        "networks": [ var.network ]
        "int_port": 80,
        "ext_port": 8010,
    }
    tier3 = {
        # 1 DB instance:
        "name": "redis",
        "image": "redis"
        "networks": [ var.network ]
        "int_port": 6379,
        "ext_port": 6379,
    }
}
