
module test {
    source = "./modules/docker-containers"

    network_name    = "apps"
    image_names     = [ "mjbright/k8s-demo:alpine1", "mjbright/k8s-demo:alpine2", "mjbright/k8s-demo:alpine3" ] 
    container_count = 3

    container_name_prefix = "test"
}


