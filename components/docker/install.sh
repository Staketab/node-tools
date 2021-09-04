#!/bin/bash

GREEN="\033[32m"
NORMAL="\033[0m"

sudo apt update \
&& sudo apt install docker.io curl -y \
&& sudo systemctl start docker \
&& sudo systemctl enable docker \
&& sudo curl -L https://github.com/docker/compose/releases/download/1.29.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
&& sudo chmod +x /usr/local/bin/docker-compose

echo "-------------------------------------------------------------------"
echo -e "$GREEN DOCKER INSTALLED.$NORMAL"
echo "-------------------------------------------------------------------"
