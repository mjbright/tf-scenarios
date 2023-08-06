#!/bin/bash

cd $( dirname $0)

ansible-playbook -i ~/ansible_inventory ./INSTALL-docker.yaml

