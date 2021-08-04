#!/bin/bash

YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"
NODENAME=$1
GRAFFITI=$2
THREADS=$3
PORT=$4

if [ "$NODENAME" == "" ]; then
    echo -e "$YELLOW none NODENAME ENV.$NORMAL"
fi
if [ "$GRAFFITI" == "" ]; then
    echo -e "$YELLOW none GRAFFITI ENV.$NORMAL"
fi
if [ "$THREADS" == "" ]; then
    echo -e "$YELLOW none THREADS ENV.$NORMAL"
fi
if [ "$PORT" == "" ]; then
    echo -e "$YELLOW none PORT ENV.$NORMAL"
fi

sudo /bin/bash -c  'echo "TAG=ghcr.io/iron-fish/ironfish:latest
THREAD='${THREADS}'
PORT='${PORT}'
" > $HOME/.env'

echo -e "$YELLOW ENV for docker-compose created.$NORMAL"
echo "---------------"

mkdir -p $HOME/.ironfish/keys
sudo /bin/bash -c  'echo "{
    \"bootstrapNodes\": [
        \"test.bn1.ironfish.network\"
    ],
    \"blockGraffiti\": \"'${GRAFFITI}'\",
    \"nodeName\": \"'${NODENAME}'\",
    \"enableSyncing\": \"true\",
    \"enableTelemetry\": \"true\"
}
" > $HOME/.ironfish/config.json'

echo -e "$YELLOW Config created.$NORMAL"
echo "---------------"

echo 'export RUN="docker run --rm --tty --interactive --net=host -v $HOME/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest"' >> $HOME/.profile
. $HOME/.profile

echo -e "$GREEN ALL settings and configs created.$NORMAL"
echo "---------------"
