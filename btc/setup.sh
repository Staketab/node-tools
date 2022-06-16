#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/logo.sh | bash

RED="\033[31m"
YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"
IP="$(curl ifconfig.me)"

function line {
echo "-------------------------------------------------------------------"
}

function setup {
  username "${1}"
  rpcport "${2}"
  chain "${3}"
}
function username {
  RPCUSER=${1}
}
function rpcport {
  RPCPORT=${1:-"8332"}
}
function chain {
  CHAIN=${1}
  if [ "$CHAIN" == "mainnet" ]; then
    CHAIN=""
    C_CHAIN="mainnet"
  elif [ "$CHAIN" == "testnet" ]; then
    CHAIN="-testnet"
    C_CHAIN="testnet"
  else
    echo -e "$RED Wrong BTC chain. Try again...$NORMAL"
    exit 0
  fi
}

function components {
    sudo apt update
    sudo apt-get install build-essential libtool wget python libssl-dev git tmux ufw jq -y
}
function nodejs {
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
}
function yarn {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
    sudo apt install yarn -y
}
function bitcoinCore {
    mkdir -p $HOME/tmp $HOME/bitcoin/
    cd $HOME/tmp
    wget https://bitcoincore.org/bin/bitcoin-core-0.21.1/bitcoin-0.21.1-x86_64-linux-gnu.tar.gz
    tar -C $HOME/bitcoin/ -xvf bitcoin-0.21.1-x86_64-linux-gnu.tar.gz --strip-components 1
    cd
    rm -rf $HOME/tmp
}
function rpcauthjs {
    git clone https://github.com/an-ivannikov-dev/bitcoin-rpcauth-js.git
    cd bitcoin-rpcauth-js
    /usr/bin/yarn install
    RPC="$(/usr/bin/yarn start ${RPCUSER})"
    RPCAUTH="$(echo $RPC | grep -o 'rpcauth=.*' | cut -f1- -d: | cut -d ' ' -f1)"
    RPCPASS="$(echo $RPC | grep -o 'rpcauth=.*' | cut -f1- -d: | cut -d ' ' -f4)"
    cd
    rm -rf $HOME/bitcoin-rpcauth-js/
}
function btcService {
sudo /bin/bash -c 'echo "[Unit]
Description=BTC Testnet node
After=network-online.target
[Service]
User='${USER}'
ExecStart=$HOME/bitcoin/bin/bitcoind '${CHAIN}' -conf=$HOME/.bitcoin/bitcoin.conf
Restart=always
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
" >/etc/systemd/system/btc.service'

sudo systemctl daemon-reload && sudo systemctl enable btc.service
}
function btcConfig {
mkdir -p $HOME/.bitcoin/
sudo /bin/bash -c 'echo "[chain]
chain='${C_CHAIN}'

[core]
daemon=1

[rpc]
server=1
rpcbind='${IP}'
rpcport='${RPCPORT}'
rpcauth=
rpcallowip=0.0.0.0/0
rpcuser='${RPCUSER}'
rpcpassword='${RPCPASS}'

# Options only for testnet
[test]
rpcbind='${IP}'
rpcauth=
rpcallowip=0.0.0.0/0
rpcport='${RPCPORT}'
rpcuser='${RPCUSER}'
rpcpassword='${RPCPASS}'

maxconnections=15
minrelaytxfee=0.0001
maxmempool=200
maxreceiverbuffer=2500
maxsendbuffer=500
dbcache=16000
" >$HOME/.bitcoin/bitcoin.conf'

sed -i.bak -E 's/rpcauth=/'${RPCAUTH}'/' $HOME/.bitcoin/bitcoin.conf
}

function configuration {
components
NODEJSDEP=$(which nodejs)
    if [ -f "$NODEJSDEP" ]; then
        line
        echo -e "$YELLOW File NODEJS exist. No need to install.$NORMAL"
        line
    else
        nodejs
        line
        echo -e "$GREEN NODEJS installed.$NORMAL"
        line
    fi
YARNDEP=$(which yarn)
    if [ -f "$YARNDEP" ]; then
        line
        echo -e "$YELLOW File YARN exist. No need to install.$NORMAL"
        line
    else
        yarn
        line
        echo -e "$GREEN YARN installed.$NORMAL"
        line
    fi
BTCCORE="$HOME/bitcoin/bin/bitcoind"
BTCCOREF="$HOME/bitcoin/"
    if [ -f "$BTCCORE" ]; then
        line
        echo -e "$YELLOW File BITCOIN CORE exist. Choose an option:$NORMAL"
        echo -e "$RED 1$NORMAL -$YELLOW Reinstall BITCOIN CORE.$NORMAL"
        echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
        line
        read -p "Your answer: " ANSWER1
        if [ "$ANSWER1" == "1" ]; then
            rm -rf $BTCCOREF
            bitcoinCore
        elif [ "$ANSWER1" == "2" ]; then
            line
            echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
            line
        fi
    else
        bitcoinCore
        line
        echo -e "$GREEN BITCOIN CORE installed.$NORMAL"
        line
    fi
rpcauthjs
}
function installation {
setup "${1}" "${2}" "${3}"
configuration
CONF="$HOME/.bitcoin/bitcoin.conf"
if [ -f "$CONF" ]; then
    line
    echo -e "$YELLOW Found an BITCOIN config. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall BITCOIN config.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    line
    read -p "Your answer: " ANSWER
    if [ "$ANSWER" == "1" ]; then
        rm -rf $CONF
        btcConfig
    elif [ "$ANSWER" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    btcConfig
    line
    echo -e "$GREEN BITCOIN config created.$NORMAL"
    line
fi

BTCSERVICE="/etc/systemd/system/btc.service"
if [ -f "$BTCSERVICE" ]; then
    line
    echo -e "$YELLOW Found an BITCOIN service. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall BITCOIN service.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    line
    read -p "Your answer: " ANSWER
    if [ "$ANSWER" == "1" ]; then
        rm -rf $BTCSERVICE
        btcService
    elif [ "$ANSWER" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    btcService
    line
    echo -e "$GREEN BITCOIN service created.$NORMAL"
    line
fi

line
echo -e "$GREEN ALL settings and configs created.$NORMAL"
line
}
function req {
    line
    echo -e "$GREEN BITCOIN CORE CONFIGURED.$NORMAL"
    line
    echo -e "$YELLOW Type$NORMAL$RED sudo systemctl start btc.service$NORMAL$YELLOW - to start BITCOIN node.$NORMAL"
    line
    echo -e "$YELLOW Type$NORMAL$RED sudo journalctl -u btc.service -f --line 100$NORMAL$YELLOW - to see the BITCOIN node logs.$NORMAL"
    line
    line
    echo -e "$GREEN Address of your bitcoin RPC server:$NORMAL"
    echo -e "$YELLOW rpc_addr = "http://${RPCUSER}:${RPCPASS}@${IP}:${RPCPORT}"$NORMAL"
    line
    echo -e "$GREEN DONE.$NORMAL"
    line
    sleep 3
}
while getopts ":u:p:c:" o; do
  case "${o}" in
    u)
      u=${OPTARG}
      ;;
    p)
      p=${OPTARG}
      ;;
    c)
      c=${OPTARG}
      ;;
  esac
done
shift $((OPTIND-1))

installation "${u}" "${p}" "${c}"
req
