
KEY=$( aws kms create-key | jq -r '.KeyMetadata.KeyId' )

aws kms encrypt --key-id $KEY --plaintext fileb://secret.yaml \
    --output text \
    --query CiphertextBlob > secret_encrypted_base64.yaml

#  aws kms list-keys | jq -r '.Keys[].KeyId'

terraform apply

# https://developer.hashicorp.com/terraform/language/functions/nonsensitive

# To force secret output:
terraform output -raw secret
terraform output -json




