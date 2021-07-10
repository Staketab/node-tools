#!/bin/bash

YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"
THREADS=$1
DIR=$2
PORT=$3

set -u

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/components/install.sh | bash

echo "TAG=ghcr.io/iron-fish/ironfish:latest
THREAD='--threads ${THREADS}'
DATA='--datadir=~/.${DIR}/'
PORT='--port=${PORT}'
" > $HOME/.env

echo -e "$YELLOW ENV for docker-compose created.$NORMAL"
echo "---------------"

echo 'export RUN="docker run --rm --tty --interactive --net=host -v $HOME/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest"' >> $HOME/.profile

echo -e "$GREEN ALL settings and configs created.$NORMAL"
echo "---------------"
