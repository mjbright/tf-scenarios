
KEY=$( aws kms create-key | jq -r '.KeyMetadata.KeyId' )

aws kms encrypt --key-id $KEY --plaintext fileb://secret.yaml \
    --output text \
    --query CiphertextBlob > secret_encrypted_base64.yaml

#  aws kms list-keys | jq -r '.Keys[].KeyId'



