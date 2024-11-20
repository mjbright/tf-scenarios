az vm list | tee ~/tmp/az.vm.list | jq '.[] | .name'
ls -al ~/tmp/az.vm.list

