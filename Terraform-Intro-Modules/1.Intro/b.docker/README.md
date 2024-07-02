
Simple Docker example which creates a Docker Image, a Docker Container connected to a new Docker network

# NOTE: sometimes strange dependency issues, just re-apply and cross fingers (assume docker provider race conditions) !

It demonstrates
- Need to specify the Provisioner
- outputing useful values, including attributes of created resources

Steps
- unset TF_DATA_DIR if set
- terraform plan # observe the error - we now are using a provisioner and so need to declare this
- mv .provider.tf provider.tf
- terraform init:
  - observe output
  - observe creation of .terraform.lock.hcl
  - observe creation of .terraform/ folder, view contents
- terraform plan # observe Plan line and Changes to Outputs (known after apply / or known already)
  # Plan: 2 to add, 0 to change, 0 to destroy.
  # Changes to Outputs:
  # + bridged_ip = (known after apply)
  # + connect    = "Connect to the container using the command 'curl http://127.0.0.1:8001'"
  # + info       = "The container container1 was created
- terraform apply # observe same Plan output, yes to accept
  # observe result
  - docker ps
  - curl CIP:80
  - curl localhost:8001
  - terraform state list
  - terraform show
  - terraform state show docker_image.image1
  - terraform state show docker_container.c1
  - terraform output
  - more terraform.tfstate
    # Note content: metadata, outputs[], resources[]
- terraform plan # observe Plan line
  # No changes. Your infrastructure matches the configuration.
- terraform apply # observe Plan line
  # Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
- Modify container resource name
  - cp .resources.tf.1 resources.tf   # NOTE: change to c1, but also var.name to /container2
  - terraform apply
  - cp .outputs.tf.1 outputs.tf
  - terraform apply
  - terraform destroy

Variations
- ... TBD ...

