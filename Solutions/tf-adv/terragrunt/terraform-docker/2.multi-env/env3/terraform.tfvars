
# backend server values:
be_network_name       = "apps3"
image_names           = [ "mjbright/k8s-demo:alpine1", "mjbright/k8s-demo:alpine2", "mjbright/k8s-demo:alpine3" ] 
container_count       = 6
base_port             = 6300
name_prefix           = "app-server-env3"

# load-balancer values:

lb_name               = "app-lb-env3"
lb_port               = 8003

ext_dashboard_port    = 30003

