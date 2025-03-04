
# aws ec2 describe-images --owner self --region us-east-1
#

JQ_TABLE() {
    jq -rc  '["ImageId","Name","CreationDate"], (.Images[] | [.ImageId, .Name, .CreationDate]) | @tsv' | column -ts $'\t'
	    #sort_by(.CreationDate) |
    #jq -rc  '["ImageId","Name","CreationDate"], (.Images[] | sort() | [.ImageId, .Name, .CreationDate]) | @tsv' | column -ts $'\t'
    # SORTS COLUMNS !! jq -rc  '["ImageId","Name","CreationDate"], (.Images[] | [.ImageId, .Name, .CreationDate] | sort) | @tsv' | column -ts $'\t'
    #jq -rc  '["ImageId","Name","CreationDate"], (.Images[] | [.ImageId, .Name, .CreationDate] | sort_by(.CreationDate)) | @tsv' | column -ts $'\t'
}

# Set REGION:
REGION="us-east-1"
[ ! -z "$AWS_DEFAULT_REGION" ] && REGION="$AWS_DEFAULT_REGION"
[ "$1" = "-r" ] && { shift; REGION=$1; shift; }

echo "Listing user images in region $REGION:"
echo "  raw json o/p saved to ~/tmp/aws/aws.ec2.images.$$.json"
echo
#ls -al ~/tmp/aws/aws.ec2.images.$$.json

if [ "$1" = "-text" ]; then
    aws ec2 describe-images --owner self --output text --region $REGION 
    exit
fi

mkdir -p ~/tmp/aws

aws ec2 describe-images --owner self --region $REGION |
        tee ~/tmp/aws/aws.ec2.images.$$.json |
        JQ_TABLE
        #jq -rc '.Images[] | { ImageId, Name, CreationDate, Tags, Tags }'

