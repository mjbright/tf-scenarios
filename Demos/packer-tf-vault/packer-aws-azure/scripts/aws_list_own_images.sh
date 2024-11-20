
REGION=us-west-2
[ ! -z "$1" ] && REGION=$1

mkdir -p ~/tmp/aws-images

JQ_INFO() {
  jq -rc '.Images[] | { Creation: .CreationDate, Name: .Name, ImageId: .ImageId, GBySize: .BlockDeviceMappings[0].Ebs.VolumeSize }'
}

if [ "$REGION" = "-a" ]; then
    REGIONS=$( aws ec2 describe-regions | jq -rc '.Regions[].RegionName' )
    #REGIONS=$( aws ec2 describe-regions | jq -rc '.Regions[].RegionName' | grep central )
    for REGION in $REGIONS; do
        #echo -e "\nListing Instances in REGION:'$REGION'..."
        
        # !! aws ec2 describe-instances --region $REGION |
        aws ec2 describe-images --owners self --region $REGION |
            tee ~/tmp/aws-images/images.${REGION}.txt |
            JQ_INFO | sed "s/{/{\"Region\":\"$REGION\",/"
    done | tee ~/tmp/aws-images/images.all.txt
    exit
fi

#DESCRIBE_SELF_IMAGES() {
#}
aws ec2 describe-images --owners self --region $REGION |
    tee ~/tmp/aws-images/images.${REGION}.txt |
    JQ_INFO


