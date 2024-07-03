
Description: 

It demonstrates
- Use of ternary operator to conditionally set an attribute in a resource
- Use of ternary operator to conditionally set the count value for a set of resources
- Best practice: always place the count line as the first line of a resource block
- Use of the random Provider to generate random strings, ids, ...

Steps
- terraform init    # observe: automatically recognizes the use of hashicorp/random, and downloads that provider
- terraform plan
- terraform apply   # Creates new container with a random 8-character lower-case name
- docker ps
- terraform destroy

Variations
- ...

