
# Automatically create:
# - a aws_key_pair for the provided key
# 

# resource "random_id" "key_pair" {
  # byte_length = 6
# }

# Provided key ----------------------------------------------

resource "aws_key_pair" "provided_key" {
  #key_name   = "auto-keypair-${ random_id.key_pair.id }"
  key_name   = "auto-keypair-packer-test"
  public_key = file( "${ local.key_file }.pub" )
}

