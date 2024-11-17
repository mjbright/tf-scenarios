
# aws ec2 describe-images --owner self --region us-east-1

REGION="us-east-1"

if [ "$1" = "-text" ]; then
    aws ec2 describe-images --owner self --output text --region $REGION 
    exit
fi

mkdir -p ~/tmp/aws

aws ec2 describe-images --owner self --region $REGION |
        tee ~/tmp/aws/aws.ec2.images.$$.json |
        jq -rc '.Images[] | { ImageId, Name, CreationDate, Tags, Tags }'

ls -al ~/tmp/aws/aws.ec2.images.$$.json
