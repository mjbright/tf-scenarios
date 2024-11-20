
if [ "$1" = "-2404" ]; then
    OP=~/tmp/az_x64_2404_images.txt
    az vm image list --architecture x64 --publisher Canonical --offer ubuntu-24_04-lts --sku server --all --output table |
        tee $OP
    head -1 $OP
    echo
    ls -al  $OP
    exit
fi

# List my images:
echo "My images in eastus:"
az vm image list --location eastus
