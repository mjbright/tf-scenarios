
# backend server values:
be_network_name       = "apps1"
image_names           = [ "mjbright/k8s-demo:alpine1", "mjbright/k8s-demo:alpine2", "mjbright/k8s-demo:alpine3" ] 
container_count       = 6
base_port             = 6100
name_prefix           = "app-server-env1"

# load-balancer values:

lb_name               = "app-lb-env1"
lb_port               = 8001

ext_dashboard_port    = 30001

