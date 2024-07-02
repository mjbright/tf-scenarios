#!/bin/bash

cat >index.html <<EOF
<html >

<head>
  <title>Server is UP</title>
</head>

<body>
  <h1>Welcome - Server $(hostname) is UP since $(date)</h1>
</body>

</html>
EOF

nohup busybox httpd -f -p ${web_port} &

sleep 2
ps -fade | grep busybox

