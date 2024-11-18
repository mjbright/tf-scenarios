  

# Set REGION:
REGION="us-east-1"
[ ! -z "$AWS_DEFAULT_REGION" ] && REGION="$AWS_DEFAULT_REGION"
[ "$1" = "-r" ] && { shift; REGION=$1; shift; }

echo "Deleting user images in region $REGION:"


for ID in $( aws ec2 describe-images --region $REGION  --owner self | jq -rc '.Images[].ImageId' ); do
    set -x
        aws ec2 deregister-image --image-id $ID --region $REGION
    set +x
done


