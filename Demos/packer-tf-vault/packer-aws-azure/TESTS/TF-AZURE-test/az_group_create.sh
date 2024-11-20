
RG=packer-test

if [ "$1" = "-rm" ];then
    #set -x; az group delete  --location eastus --resource-group $RG; set +x
    set -x; az group delete --resource-group $RG; set +x
elif [ "$1" = "-ls" ];then
    #az group list  --location eastus
    az group list | jq -rc '.[] | { name, location }'
else
    set -x; az group create --location eastus --resource-group $RG; set +x
fi
#az group create  --location eastus --resource-group student
