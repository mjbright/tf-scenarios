
Description: Demonstrate use of for_each / compare with use of count

It demonstrates
- Use for_each token to create multiple resource instances based on a map (or set) variable
- Demonstrates the problem with using count, if we delete an element of the list (all following elements are recreated)
- Demonstrates the advantages of using for_each
  - convenient declaration of attributes as a map variable
  - removal of one element from the map e.g. "vm2", causes the deletion only of "vm2"
- (TBD) Possible use of merge to merge a default & specific config map variable

Steps
- Starting from the initial container.tf (.container.tf.count)
- terraform init
- terraform apply   # Creates 5 new "VMs"
- docker ps
- Modify container.tf # remove the "vm2" value from the var.vm_names list
- terraform apply   # Observe that instead of deleting one "VM" "vm2",
                    # it actually deletes "vm2" and also deletes/recreates "vm3", "vm4", "vm5"
                    # because of their position after "vm2" in the list
- terraform destroy
- cp .containers.tf.for_each containers.tf
- terraform apply   # Creates 5 new "VMs"
                    # observe how the attributes are stored in a map variable
                    # could be populated from a *.tfvars file*
- docker ps
- Modify container.tf # remove the "vm2" value from the var.vm_names list
                      # Observe that this time, only "vm2" is deleted
- terraform destroy

Variations
- ...

