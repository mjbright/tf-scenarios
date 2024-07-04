
Description: Demonstrate use of for_in loops to transform/filter data structures

Use cases:
- transform/filter data structures in a suitable form prior to creating resources (esp. with for_each)
- transform data for use in output blocks

It demonstrates
- Transformations from List to List, with or without filtering
- Transformations from Map  to List, with or without filtering
- Transformations from List to Map , with or without filtering
- Transformations from Map  to Map , with or without filtering
- A more practical example for building up pretty output

Steps
- Copy each of the following files to outputs.tf and perform "terraform apply"
 .outputs.tf.list2list
 .outputs.tf.list2map
 .outputs.tf.map2list
 .outputs.tf.map2map
 .outputs.tf.summary
- Observe the transformed values

- terraform destroy

Variations
- ...

