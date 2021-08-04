#!/bin/bash

GREEN="\033[32m"

sudo apt update && sudo apt upgrade -y \
&& sudo apt install docker.io curl -y \
&& sudo systemctl start docker \
&& sudo systemctl enable docker \
&& sudo curl -L https://github.com/docker/compose/releases/download/1.29.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
&& sudo chmod +x /usr/local/bin/docker-compose \
&& sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python libssl-dev git cmake make perl tmux ufw gcc unzip zip jq golang-statik -y


echo "---------------"
echo -e "$GREEN ALL COMPONENTS INSTALLED.\033[0m"
echo "---------------"
