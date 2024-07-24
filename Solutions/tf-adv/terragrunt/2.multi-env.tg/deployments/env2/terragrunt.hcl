
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/root"
}

inputs = {
  # backend server values:
  be_network_name       = "apps2"
  image_names           = [ "mjbright/k8s-demo:alpine1", "mjbright/k8s-demo:alpine2", "mjbright/k8s-demo:alpine3" ] 
  container_count       = 6
  base_port             = 6200
  name_prefix           = "app-server-env2"

  # load-balancer values:

  lb_name               = "app-lb-env2"
  lb_port               = 8002

  ext_dashboard_port    = 30002
}

