#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/logo.sh | bash

set -e

GREEN="\033[32m"
NORMAL="\033[0m"
VERSION=$1

if [ "$VERSION" == "" ]; then
    VERSION="2.15.0"
fi

export VERSION="$VERSION" \
&& sudo apt update \
&& sudo apt install docker.io curl -y \
&& sudo systemctl start docker \
&& sudo systemctl enable docker \
&& sudo curl -L https://github.com/docker/compose/releases/download/v$VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
&& sudo chmod +x /usr/local/bin/docker-compose

echo "-------------------------------------------------------------------"
echo -e "$GREEN DOCKER v$VERSION INSTALLED.$NORMAL"
echo "-------------------------------------------------------------------"
