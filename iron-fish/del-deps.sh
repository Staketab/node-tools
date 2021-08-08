#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/staketab+ironfish.sh | bash

YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
NORMAL="\033[0m"

function line {
echo "-------------------------------------------------------------------"
}

function uninstalling {
line
echo -e "$YELLOW Backuping keys.$NORMAL"
line
# ACC="$($RUN accounts:which)"
# mkdir -p $HOME/.ironfish/keys \
# && $RUN accounts:export ${ACC} $HOME/.ironfish/keys/${ACC}.json
sudo systemctl stop ironfish
sudo systemctl stop ironfish-miner
DATE="$(date +%F-%H-%M-%S)"
mkdir -p $HOME/ironfish-backup_$DATE/keys $HOME/ironfish-backup_$DATE/accounts \
&& cp -r $HOME/.ironfish/keys/* $HOME/ironfish-backup_$DATE/keys \
&& cp -r $HOME/.ironfish/accounts/* $HOME/ironfish-backup_$DATE/accounts

line
echo -e "$GREEN DONE.$NORMAL"
line
sleep 2

line
echo -e "$YELLOW Uninstalling components.$NORMAL"
line

. $HOME/.profile
. $HOME/.cargo/env

NODEJSDEP=$(which nodejs)
    if [ -f "$NODEJSDEP" ]; then
        line
        echo -e "$YELLOW File $NODEJS exist. Deleting...$NORMAL"
        line
        sudo apt-get remove nodejs -y
        sleep 1
    else
        line
        echo -e "$GREEN NODEJS not found.$NORMAL"
        line
    fi

WASMDEP=$(which wasm-pack)
    if [ -f "$WASMDEP" ]; then
        line
        echo -e "$YELLOW File $WASM exist. Deleting...$NORMAL"
        line
        rm $(which wasm-pack)
        sleep 1
    else
        line
        echo -e "$GREEN WASM not found.$NORMAL"
        line
    fi

CARGODEP=$(which cargo)
    if [ -f "$CARGODEP" ]; then
        line
        echo -e "$YELLOW File $CARGO exist. Deleting...$NORMAL"
        line
        rustup self uninstall -y
        sleep 1
    else
        . $HOME/.cargo/env
        line
        echo -e "$GREEN CARGO not found.$NORMAL"
        line
    fi

YARNDEP=$(which yarn)
    if [ -f "$YARNDEP" ]; then
        line
        echo -e "$YELLOW File $YARN exist. Deleting...$NORMAL"
        line
        sudo apt-get remove yarn -y && sudo apt-get purge yarn -y
        sleep 1
    else
        line
        echo -e "$GREEN YARN not found.$NORMAL"
        line
    fi
PROJECT="$HOME/ironfish"
    if [ -e "$PROJECT" ]; then
        line
        echo -e "$YELLOW Found an $PROJECT directory. Deleting...$NORMAL"
        line
        rm -rf $PROJECT
        sleep 1
    else
        line
        echo -e "$GREEN Directory $PROJECT not found.$NORMAL"
        line
    fi
PROJECT2="$HOME/.ironfish"
    if [ -e "$PROJECT2" ]; then
        line
        echo -e "$YELLOW Found an $PROJECT2 directory. Deleting...$NORMAL"
        line
        rm -rf $PROJECT2
        sleep 1
    else
        line
        echo -e "$GREEN Directory $PROJECT2 not found.$NORMAL"
        line
    fi
NODE="/etc/systemd/system/ironfish.service"
    if [ -f "$NODE" ]; then
        line
        echo -e "$YELLOW File $NODE exist. Deleting...$NORMAL"
        line
        rm -rf $NODE
        sleep 1
    else
        line
        echo -e "$GREEN $NODE not found.$NORMAL"
        line
    fi
MINER="/etc/systemd/system/ironfish-miner.service"
    if [ -f "$MINER" ]; then
        line
        echo -e "$YELLOW File $MINER exist. Deleting...$NORMAL"
        line
        rm -rf $MINER
        sleep 1
    else
        line
        echo -e "$GREEN $MINER not found.$NORMAL"
        line
    fi
ENV="$HOME/.env"
    if [ -f "$ENV" ]; then
        line
        echo -e "$YELLOW File $ENV exist. Deleting...$NORMAL"
        line
        rm -rf $ENV
        sleep 1
    else
        line
        echo -e "$GREEN $ENV not found.$NORMAL"
        line
    fi
COMPOSE="$HOME/docker-compose.yaml"
    if [ -f "$COMPOSE" ]; then
        line
        echo -e "$YELLOW File $COMPOSE exist. Deleting...$NORMAL"
        line
        rm -rf $COMPOSE
        sleep 1
    else
        line
        echo -e "$GREEN $COMPOSE not found.$NORMAL"
        line
    fi
line
echo -e "$GREEN ALL DONE.$NORMAL"
line
sleep 2
}

uninstalling
