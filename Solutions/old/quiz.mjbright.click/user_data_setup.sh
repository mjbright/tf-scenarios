#!/usr/bin/env bash
#!/bin/bash

# AS root:
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y python3-venv

# AS ubuntu::

sudo -i -u ubuntu bash << EOF
    mkdir -p ~/.venv/

    python3 -m venv ~/.venv/flask

    . ~/.venv/flask/bin/activate

    python3 -m pip install flask

    cat <<INNER_EOF >> /home/ubuntu/.bashrc
set -o vi
. ~/.venv/flask/bin/activate
INNER_EOF

EOF




