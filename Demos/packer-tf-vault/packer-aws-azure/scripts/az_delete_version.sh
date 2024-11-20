
vars_file=BUILD-azure/variables.auto.pkrvars.hcl

#image_version          = "0.0.1"
#resource_group         = "packer-test"
#gallery_resource_group = "image-gallery"
#gallery_name           = "packerimages"

RG=$( awk -F= '/gallery_resource_group/ { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
GN=$( awk -F= '/gallery_name/           { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
GIN=$( awk -F= '/gallery_image_name/    { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
GIV=$( awk -F= '/gallery_image_version/ { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
echo "RG='$RG'"
echo "GN='$GN'"
echo "GIN='$GIN'"
echo "GIV='$GIV'"
set -x
az sig image-version list --resource-group $RG --gallery-name $GN --gallery-image-name $GIN | tee ~/tmp/az.gallery.image.versions.json |  jq -rc '.[] | { name, location, id }'
#exit
#exit
#az sig image-version list --resource-group $RG --gallery-name $GN --gallery-image-name $GIN | jq '.[].version'
#exit
#az sig image-version delete --resource-group $RG --gallery-name $GN --gallery-image-name $GIN --gallery-image-version $GIN
 az sig image-version delete --resource-group $RG --gallery-name $GN --gallery-image-definition $GIN --gallery-image-version $GIN

az sig image-version list --resource-group $RG --gallery-name $GN --gallery-image-name $GIN | tee ~/tmp/az.gallery.image.versions.json |  jq -rc '.[] | { name, location, id }'
exit



