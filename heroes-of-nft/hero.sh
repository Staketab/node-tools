#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/logo.sh | bash

set -e

YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"
VERSION=${1:-"1.9.0"}
TAG=${2:-"1.9.0"}
NETWORK=${3:-"fuji"}
HOST=${4:-"0.0.0.0"}
PORT=${5:-"9650"}
SUBNET=${6:-"2q5qfMjarA3PJDEe594LFY2sHqNuD95CAkhkQTMY4Z6aHndgXT"}
SERVERIP="$(curl ifconfig.me)"

function service {
sudo /bin/bash -c  'echo "[Unit]
Description=Avalanche Node
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
WorkingDirectory=$HOME
Restart=on-failure
RestartSec=3
LimitNOFILE=65536
ExecStart=$HOME/hero-node/avalanchego --network-id='${NETWORK}' --public-ip='${SERVERIP}' --http-host='${HOST}' --http-port='${PORT}' --whitelisted-subnets='${SUBNET}'
[Install]
WantedBy=multi-user.target
" >/etc/systemd/system/hero.service'
}

function aliases {
mkdir -p $HOME/.avalanchego/vms/
sudo /bin/bash -c  'echo "{
  \"nyfSdRoaSxyQUqMMQAVNaGR2bin6HRLC1yrRdEZRpfFrDiUk8\": [\"hero\", \"herovm\", \"hvm\"]
}" > $HOME/.avalanchego/vms/aliases.json'
}

function install {
cd \
&& export VERSION="$VERSION" && export TAG="$TAG"

if [ -e /etc/systemd/system/hero.service ]; then
  echo -e "$YELLOW --------Hero Service found.--------$NORMAL"
  sudo systemctl stop hero
  rm -rf /etc/systemd/system/hero.service
  service
  sudo systemctl enable hero.service
  aliases
  echo "-------------------------------------------------------------------"
  echo -e "$YELLOW --------Hero service replaced.--------$NORMAL"
  echo "-------------------------------------------------------------------"
else
  service
  sudo systemctl enable hero.service
  aliases
  echo "-------------------------------------------------------------------"
  echo -e "$YELLOW --------Hero service installed.--------$NORMAL"
  echo "-------------------------------------------------------------------"
fi
}

function subnetEvm {
if [ -e $HOME/subnet-evm_0.3.0_darwin_arm64.tar.gz ]; then
  rm -rf $HOME/subnet-evm_0.3.0_darwin_arm64.tar.gz
  wget https://github.com/ava-labs/subnet-evm/releases/download/v0.3.0/subnet-evm_0.3.0_darwin_arm64.tar.gz
else
  wget https://github.com/ava-labs/subnet-evm/releases/download/v0.3.0/subnet-evm_0.3.0_darwin_arm64.tar.gz
fi
mkdir -p $HOME/tmp
tar -C $HOME/tmp/ -xvf subnet-evm_0.3.0_darwin_arm64.tar.gz \
&& rm -rf $HOME/subnet-evm_0.3.0_darwin_arm64.tar.gz
mv $HOME/tmp/subnet-evm $HOME/hero-node/plugins/nyfSdRoaSxyQUqMMQAVNaGR2bin6HRLC1yrRdEZRpfFrDiUk8
rm -rf $HOME/tmp

echo "-------------------------------------------------------------------"
echo -e "$GREEN --------SUBNET EVM VERSION v0.3.0 INSTALLED--------$NORMAL"
echo "-------------------------------------------------------------------"
}

function update {
if [ -e $HOME/avalanchego-linux-amd64-v$VERSION.tar.gz ]; then
  rm -rf $HOME/avalanchego-linux-amd64-v$VERSION.tar.gz
  wget https://github.com/ava-labs/avalanchego/releases/download/v$TAG/avalanchego-linux-amd64-v$VERSION.tar.gz
else
  wget https://github.com/ava-labs/avalanchego/releases/download/v$TAG/avalanchego-linux-amd64-v$VERSION.tar.gz
fi

mkdir -p $HOME/hero-node $HOME/hero-node/plugins

tar -C $HOME/hero-node -xvf avalanchego-linux-amd64-v$VERSION.tar.gz --strip-components 1 \
&& rm -rf $HOME/avalanchego-linux-amd64-v$VERSION.tar.gz

subnetEvm

sudo systemctl daemon-reload && sudo systemctl restart hero.service

echo "-------------------------------------------------------------------"
echo -e "$GREEN --------HERO VERSION v$VERSION INSTALLED--------$NORMAL"
echo "-------------------------------------------------------------------"
}

install
update
