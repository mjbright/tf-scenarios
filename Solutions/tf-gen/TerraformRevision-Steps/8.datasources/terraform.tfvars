
domain_name = "local"

int_port = 80

containers = {
    "c1": {
        "image":    "mjbright/k8s-demo:alpine1",
        "ext_port": 8001
    },
    "c2": {
        "image":    "mjbright/k8s-demo:alpine2",
        "ext_port": 8002
    },
    "c3": {
        "image":    "mjbright/k8s-demo:alpine3",
        "ext_port": 8003
    },
    "c4": {
        "image":    "mjbright/k8s-demo:alpine4",
        "ext_port": 8004
    },
    "c5": {
        "image":    "mjbright/k8s-demo:alpine5",
        "ext_port": 8005
    },
}
