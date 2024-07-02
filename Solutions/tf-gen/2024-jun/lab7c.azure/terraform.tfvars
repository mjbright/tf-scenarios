
key_file     = "key.pem"
key_ppk_file = "key.ppk"

location   = "westus"

############## START: TO CHANGE ###################

## Put your student name here:
resource_group = "studentn"

## Choose a unique value here - e.g. your student name
host        = "instance-name"

############## END:   TO CHANGE ###################

#resource_group = "student"


pub_ingress_ports = {
    "ssh":            [22,22], # Enable incoming ssh         connection
    "web"  :      [8080,8080], # Enable incoming web-server  connection
    "flask":      [3000,3000], # Enable incoming flask(quiz) connection
    "high"  :   [30000,32767], # Enable incoming connections to high-numbered ports
}

vpc_ingress_ports = {
    "":             [0,0]
}

egress_ports = {
    "http":    [80,80], # Enable outgoing http  connections
    "https": [443,443], # Enable outgoing https connections
}

net_cidr    = "192.168.0.0/20"
subnet_cidr = "192.168.0.0/24"

# user data:
user_data_file = "user_data_setup.sh"

# remote_exec/file provisioners:
provisioner_templatefile = "/dev/null"

files_to_transfer = [
  "/etc/hosts", "/etc/lsb-release",
]

# zip_files = [ "files/files.zip" ]

intra_pub_key_file = ""
intra_key_file = ""

# -- Choice of VM size: ---------------------------------------------------------------
# See: https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
#vm_size        = "Standard_D2s_v3"
vm_size        = "Standard_B1ms"

# -- Choice of VM image:---------------------------------------------------------------
image_publisher = "Canonical"
image_offer     = "0001-com-ubuntu-server-focal"
image_sku       = "20_04-lts"
image_version   = "latest"
#image_version   = "20.04.202201310"

prefix = "aztest"

