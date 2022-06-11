#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/logo.sh | bash

set -e

GREEN="\033[32m"
NORMAL="\033[0m"
VERSION=$1

if [ "$VERSION" == "" ]; then
    VERSION="3.8.5"
fi

cd \
&& export VERSION="$VERSION" \
&& wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz \
&& tar -xvf Python-$VERSION.tar.xz \
&& cd Python-$VERSION \
&& sudo apt-get install zlib1g-dev \
&& ./configure \
&& make \
&& make install \
&& python3 -V

echo "$GREEN--------PYTHON VERSION v$VERSION INSTALLED--------$NORMAL"