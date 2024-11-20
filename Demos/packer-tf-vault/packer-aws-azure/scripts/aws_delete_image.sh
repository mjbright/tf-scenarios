
AMI_ID=UNSET
[ ! -z "$AMI_ID" ] && AMI_ID=$1

set -x
aws ec2 deregister-image --image-id $AMI_ID --region us-west-2


