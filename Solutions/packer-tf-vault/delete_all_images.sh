  

REGION=us-east-1


for ID in $( aws ec2 describe-images --region $REGION  --owner self | jq -rc '.Images[].ImageId' ); do
    set -x
        aws ec2 deregister-image --image-id $ID --region $REGION
    set +x
done


