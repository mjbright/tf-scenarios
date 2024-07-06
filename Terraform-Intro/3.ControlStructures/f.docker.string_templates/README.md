
Description: Demonstrate the use of string templates / templatefile() function

Use cases:
- Build up strings from a template, populated according to provided variables
- Strings can be used in output blocks, local_file resources
- Strings could represent config files, e.g.
  - ssh_config file setup to allow connectivity to created VMs
  - ansible_inventory file setup to allow connectivity to created VMs
- Strings could represent any text, e.g.
  - a readable report describing the created resources


Steps
- terraform init
- terraform apply # TBD
                  # TBD
- cat results ...
- investigate the template file: tpl/results.tpl

- terraform destroy

Variations
- ...

