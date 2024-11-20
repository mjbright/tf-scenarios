
RG=packer-test

GALLERY_RG=image-gallery
GALLERY_NAME="packerimages"
IMAGE="ubuntu-24.04-vnc"

if [ "$1" = "-images" ];then
    #IMAGE="test-ubuntu-20.04"
    # set -x; az group create --location eastus --resource-group $GALLERY_RG; set +x

    ## IMAGE="test-ubuntu-20.04"
    ## az sig image-definition delete -g "$GALLERY_RG" -r "$GALLERY_NAME" -i $IMAGE
    ## exit
    ## IMAGE="ubuntu-24.04-vnc"
    set -x
    az sig create -g "$GALLERY_RG" -r "$GALLERY_NAME"
    # create a definition
    az sig image-definition create -g "$GALLERY_RG" \
        -r "$GALLERY_NAME" -i $IMAGE \
        --publisher self --offer selfoffer --sku selfsku \
        --os-type linux --os-state Generalized \
        --hyper-v-generation V2
    set +x
    # az sig image-definition list --resource-group image-gallery --gallery-name packerimages
    # az sig image-definition list --resource-group $GALLERY_RG --gallery-name $GALLERY_NAME
    # az sig image-version delete --resource-group image-gallery --gallery-name packerimages --gallery-image-definition ubuntu-24.04-vnc --gallery-image-version 1.0.0
    # az sig image-version delete --resource-group image-gallery --gallery-name packerimages --gallery-image-name ubuntu-24.04-vnc
    #
    # az sig image-definition delete --resource-group image-gallery --gallery-name packerimages -i /subscriptions/3b20a4d3-fada-4ca5-ba45-463d15da5239/resourceGroups/image-gallery/providers/Microsoft.Compute/galleries/packerimages/images/ubuntu-24.04-vnc
    # az sig image-definition delete --resource-group $GALLERY_RG --gallery-name $GALLERY_NAME -i /subscriptions/3b20a4d3-fada-4ca5-ba45-463d15da5239/resourceGroups/image-gallery/providers/Microsoft.Compute/galleries/packerimages/images/ubuntu-24.04-vnc
    # az sig image-definition delete --resource-group image-gallery --gallery-name packerimages -i ubuntu-24.04-vnc
    # az sig image-definition delete --resource-group image-gallery --gallery-name packerimages -i ubuntu-24.04-vnc/versions/1.0.0
fi
