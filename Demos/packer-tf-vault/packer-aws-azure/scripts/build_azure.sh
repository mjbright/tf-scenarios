
# az login

mkdir -p ~/tmp/packer_build

PKR_DIR=BUILD-azure
TF_DIR=$PKR_DIR/TF-AZURE-test

LOG="$HOME/tmp/packer_build/build_azure.op.txt"

die() { echo "$0: die - $*" >&2; exit 1; }

DELETE_PREV_VERSION_P() {
    vars_file=$PKR_DIR/variables.auto.pkrvars.hcl

    RG=$( awk -F= '/gallery_resource_group/ { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
    GN=$( awk -F= '/gallery_name/           { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
    GIN=$( awk -F= '/gallery_image_name/    { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
    GIV=$( awk -F= '/gallery_image_version/ { print $2; }' $vars_file | sed -e 's/ *//g' -e 's/"//g' )
    echo "RG='$RG'"
    echo "GN='$GN'"
    echo "GIN='$GIN'"
    echo "GIV='$GIV'"
    #set -x
    echo "Image versions: before deletion ($GIV)"
    az sig image-version list --resource-group $RG --gallery-name $GN --gallery-image-name $GIN |
        tee ~/tmp/az.gallery.image.versions.before-delete.json |
        jq -rc '.[] |
        { name, location, id }' | tee ~/tmp/az.gallery.image.versions.txt

     grep $GIV ~/tmp/az.gallery.image.versions.txt ||
         { echo "No match on '$GIV'"; return 0; }

#    echo "Deleting image version '$GIV' [SLOW]"
     set -x
     time az sig image-version delete --resource-group $RG --gallery-name $GN --gallery-image-definition $GIN --gallery-image-version $GIN
     set +x

    echo "Image versions: after deletion ($GIV)"
     az sig image-version list --resource-group $RG --gallery-name $GN --gallery-image-name $GIN | tee ~/tmp/az.gallery.image.versions.after-delete.json |  jq -rc '.[] | { name, location, id }'
}

TIMER_hhmmss() {
    _REM_SECS=$1; shift

    let SECS=_REM_SECS%60

    let _REM_SECS=_REM_SECS-SECS
    let      MINS=_REM_SECS/60%60
    let _REM_SECS=_REM_SECS-60*MINS
    let       HRS=_REM_SECS/3600

    [ $SECS -lt 10 ] && SECS="0$SECS"
    [ $MINS -lt 10 ] && MINS="0$MINS"
}

GET_IMAGE_INFO() {
    #AMI=$( tail -10 "$LOG" | awk '/ManagedImageId:/ { print $2; }' )
    AMI=$( tail -10 "$LOG" | awk '/ManagedImageSharedImageGalleryId:/ { print $2; }' )
    #AMI=$( tail -10 "$LOG" | awk '/ManagedImageName:/ { print $2; }' )
    echo "AMI=$AMI"

    # ManagedImageName: ub2204-vnc-az-2024-07-08-055606
    # ManagedImageId: /subscriptions/3b20a4d3-fada-4ca5-ba45-463d15da5239/resourceGroups/packer-test/providers/Microsoft.Compute/images/ub2204-vnc-az-2024-07-08-055606

    [ ! -z "$AMI" ] && {
        [ -f $TF_DIR/ami.auto.tfvars ] &&
            mv $TF_DIR/ami.auto.tfvars $TF_DIR/ami.auto.tfvars.prev
        echo "image_id = \"$AMI\"" > $TF_DIR/ami.auto.tfvars

        echo "Updated file $TF_DIR/ami.auto.tfvars with ami='$AMI'"
    }
}

if [ "$1" = "-rmi" ]; then
    DELETE_PREV_VERSION_P
    exit
fi

if [ "$1" = "-image" ]; then
    GET_IMAGE_INFO 1
    exit
fi

[ -s "$LOG" ] &&
    { set -x; mv "$LOG" "${LOG}.prev"; set +x; }

echo "Writing packer output to '$LOG'"

## == Packer init ==================================
T0=$SECONDS
CMD="packer init $PKR_DIR/"
    echo "== $CMD"; $CMD; RES=$?
T1=$SECONDS
let TOOK=T1-T0
echo "Packer init took $TOOK secs"
[ $RES -ne 0 ] && die "Packer init error"

## == Packer build==================================
T0=$SECONDS
CMD="packer build $PKR_DIR/ | tee $LOG"
    echo "== $CMD"; eval $CMD; RES=$?
T1=$SECONDS
let TOOK=T1-T0
TIMER_hhmmss $TOOK
#echo "Packer build took $TOOK secs"
#echo "Packer build took ${HRS}h ${MINS}m ${SECS}s"
echo "Packer build took ${MINS}m ${SECS}s" | tee -a $LOG

[ $RES -ne 0 ] && die "Packer build error"

#    echo "GET_IMAGE_INFO 2"
GET_IMAGE_INFO

ls -al $LOG
echo "Wrote packer output to '$LOG'"

