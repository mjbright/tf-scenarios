
# sensitive variables will be redacted in any outputs, but will still appear in the terraform.tfstate
variable secure_user {
    sensitive = true
}

variable secure_password {
    sensitive = true
}

# sensitive variables will be visibale in any outputs, but will still appear in the terraform.tfstate
variable insecure_user {
    # DEFAULT: sensitive = false
}

variable insecure_password {
    # DEFAULT: sensitive = false
}

# local variables will adopt the sensitivty of the variablles used:
locals {
   secure_login   = "${ var.secure_user } / ${ var.secure_password }"
   insecure_login = "${ var.insecure_user } / ${ var.insecure_password }"
}

output secure_login {
    value = "Secure login details = ${ local.secure_login }"

    # Terraform obligies us to set the sensitivity here:
    sensitive = true
}

output insecure_login {
    value = "Secure login details = ${ local.insecure_login }"
}

