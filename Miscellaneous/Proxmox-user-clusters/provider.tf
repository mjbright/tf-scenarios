
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

provider "proxmox" {
    pm_api_url      = var.pm_api_url
    pm_tls_insecure = "true"
    pm_otp          = ""

    # Set PM_USER/PM_PASS via ~/tf.setup.rc
    #pm_user     = "root@pam"
    #pm_password = "PASSWORD"
}

