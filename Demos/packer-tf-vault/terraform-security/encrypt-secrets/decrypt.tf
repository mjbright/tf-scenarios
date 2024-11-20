
locals {
    encr_file = "secret_encrypted_base64.yaml"
}

data "aws_kms_secrets" "creds" {
  secret {
    name        = "db"
    payload     = file("${local.encr_file}")
  }
}

output secret {
   value = "Secret = ${ jsonencode( data.aws_kms_secrets.creds.plaintext ) }"
   sensitive = true
}

output show_secret {
   value = nonsensitive( "Secret = ${ jsonencode( data.aws_kms_secrets.creds.plaintext ) }" )
}

