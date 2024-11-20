
## Common Variables: ==============================================================

# NOTE: See BELOW in "Proxmox Variables:" for proxmox_source_builds
source_builds   = ["source.amazon-ebs.vnc", "source.azure-arm.vnc"]
#source_builds   = ["source.amazon-ebs.vnc"]
#source_builds   = ["source.docker.vnc"]

#apt_packages   = "sudo btop tmux vim evince xfce4 xfce4-terminal tightvncserver"
#apt_packages   = "btop tmux vim evince xfce4 xfce4-terminal tightvncserver"
#apt_packages   = "docker.io btop vim evince xfce4 xfce4-terminal tightvncserver curl python3-pip python3-venv tmux tmate zip unzip jq sysvbanner rename"
apt_packages   = "docker.io btop vim"


# MANUAL install post VM creation:
# - terraform: terraform, terragrunt, graphviz, tfenv
# - kubernetes: k9s, download (apt-get install -d) kubectl/adm/let
#               SEPARATE BASE IMAGE for LF: REMOVE docker/containerd for LinuxFoundation courses ...



## AWS Variables: =================================================================

aws_access_key = "{{env `AWS_ACCESS_KEY_ID`}}"
aws_secret_key = "{{env `AWS_SECRET_ACCESS_KEY`}}"

#aws_regions = ["us-west-1"]
aws_regions = ["us-west-2", "us-west-1"]
#aws_regions = ["us-west-1", "us-west-2"]
instance_type  = "t2.medium"

## Azure Variables: ===============================================================

resource_group         = "packer-test"
gallery_resource_group = "image-gallery"
gallery_name           = "packerimages"
gallery_image_name     = "ubuntu-24.04-vnc"
#gallery_image_version  = "0.0.1"
gallery_image_version  = "0.0.3"

## Proxmox Variables: =============================================================

proxmox_source_builds   = ["source.proxmox-iso.vnc"]

