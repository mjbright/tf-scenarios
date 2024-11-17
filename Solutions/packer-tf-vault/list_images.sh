
# aws ec2 describe-images --owner self --region us-east-1

mkdir -p ~/tmp/aws

aws ec2 describe-images --owner self --region us-east-1 |
        tee ~/tmp/aws/aws.ec2.images.$$.json |
        jq -rc '.Images[] | { ImageId, Name, CreationDate, Tags, Tags }'

ls -al ~/tmp/aws/aws.ec2.images.$$.json
