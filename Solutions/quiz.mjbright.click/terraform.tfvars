
key_file = "key.pem"

ingress_ports = {
    "ssh":     22, # Enable incoming ssh         connection
    "web"  : 8080, # Enable incoming web-server  connection
    "flask": 3000  # Enable incoming flask(quiz) connection
}

egress_ports = {
    "http":   80, # Enable outgoing http  connections
    "https": 443  # Enable outgoing https connections
}

# DNS Domain info:
domain             = "YOUR-DOMAIN.NET"
zone_id            = "/hostedzone/YOUR-DOMAIN-ID"

# user data:
user_data_filepath = "user_data_setup.sh"

