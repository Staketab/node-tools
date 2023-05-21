#!/bin/bash

GREEN="\033[32m"
NORMAL="\033[0m"

sudo apt update && sudo apt upgrade -y \
&& sudo apt install docker.io curl -y \
&& sudo systemctl start docker \
&& sudo systemctl enable docker \
&& sudo wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/v2.17.0/docker-compose-`uname -s`-`uname -m` \
&& sudo chmod +x /usr/local/bin/docker-compose \
&& sudo apt-get install build-essential curl libpq-dev ocaml ocamlbuild automake autoconf libtool wget python libssl-dev git cmake make perl tmux ufw gcc unzip zip jq golang-statik -y


echo "-------------------------------------------------------------------"
echo -e "$GREEN ALL COMPONENTS INSTALLED.$NORMAL"
echo "-------------------------------------------------------------------"
