#!/bin/bash
# Start docker
start-docker.sh


service ssh start
# Execute specified command

#Cloud Init
/cloudinit/init.sh

echo "ENV created"
"$@"
