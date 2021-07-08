#!/bin/bash

YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/components/install.sh | bash

echo -e "$YELLOW Components updated.$NORMAL"
echo "---------------"

echo "TAG=ghcr.io/iron-fish/ironfish:latest" > $HOME/.env

echo -e "$YELLOW ENV for docker-compose created.$NORMAL"
echo "---------------"

echo 'export RUN="docker run --rm --tty --interactive --net=host -v $HOME/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest"' >> $HOME/.profile

echo -e "$GREEN ALL settings and configs created.$NORMAL"
echo "---------------"
