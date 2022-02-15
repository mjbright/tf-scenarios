
output public_ips { value = aws_instance.web_server.*.public_ip }

output public_dns { value = aws_instance.web_server.*.public_dns }

output private_ips { value = aws_instance.web_server.*.private_ip }

output vms_info {
  value = [ for index, ws in aws_instance.web_server.* :
      "VM ${index} details: ${ws.public_ip}, ${ws.public_dns}, ${ws.private_ip}"
  ]
}

