
terraform plan | grep Plan:

grep -E " cpu_set | env " imported_resources.tf 

sed -i.bak -e 's/env *= null/env = []/' -e 's/cpu_set *=.*/cpu_set = 1/' imported_resources.tf 
terraform plan | grep Plan:


diff imported_resources.tf.*

