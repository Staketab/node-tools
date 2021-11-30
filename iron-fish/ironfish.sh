#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/staketab+ironfish.sh | bash

YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
NORMAL="\033[0m"

function line {
echo "-------------------------------------------------------------------"
}

function setup {
  nodename "${1}"
  graffiti "${2}"
  threads "${3}"
  port "${4}"
}

function nodename {
  NODENAME=${1}
}

function graffiti {
  GRAFFITI=${1}
}

function threads {
  THREADS=--threads=${1:-"-1"}
}

function port {
  PORT=--port=${1:-"9033"}
}
function vars {
    . $HOME/.cargo/env
    . $HOME/.profile
    source $HOME/.profile
}
function limit {
    ulimit -c 0
}
function profiles {
    echo 'export RUN="yarn --cwd $HOME/ironfish/ironfish-cli/ start:once"' >> $HOME/.profile
    vars
}
function components {
    sudo apt update
    sudo apt-get install build-essential libtool wget python libssl-dev git tmux ufw jq -y
}
function nodejs {
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs
}
function rust {
    curl https://getsubstrate.io/ -sSf | bash -s -- --fast
    vars
}
function wasm {
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
}
function yarn {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
    sudo apt install yarn -y
}
function config {
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

    line
    echo -e "$GREEN Ironfish config created.$NORMAL"
    line
}
function ironfishMiner {
    sudo /bin/bash -c  'echo "[Unit]
    Description=Ironfish-miner Node
    After=network.target
    [Service]
    Type=simple
    WorkingDirectory=$HOME
    Restart=always
    RestartSec=3
    LimitNOFILE=50000
    ExecStart=/usr/bin/yarn --cwd $HOME/ironfish/ironfish-cli/ start miners:start '${THREADS}'
    [Install]
    WantedBy=multi-user.target
    " >/etc/systemd/system/ironfish-miner.service'

    sudo systemctl daemon-reload && sudo systemctl enable ironfish-miner.service
}
function ironfish {
    sudo /bin/bash -c  'echo "[Unit]
    Description=Ironfish Node
    After=network.target
    [Service]
    Type=simple
    WorkingDirectory=$HOME
    Restart=always
    RestartSec=3
    LimitNOFILE=50000
    ExecStart=/usr/bin/yarn --cwd $HOME/ironfish/ironfish-cli/ start start '${PORT}'
    [Install]
    WantedBy=multi-user.target
    " >/etc/systemd/system/ironfish.service'

    sudo systemctl daemon-reload && sudo systemctl enable ironfish.service
}
function build {
    vars
    cd $HOME
    git clone https://github.com/iron-fish/ironfish
    cd $HOME/ironfish
    cargo install --force wasm-pack
    cd
    /usr/bin/yarn --cwd $HOME/ironfish/

}
function setupDep {
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

CARGODEP=$(which cargo)
    if [ -f "$CARGODEP" ]; then
        line
        echo -e "$YELLOW File CARGO exist. No need to install.$NORMAL"
        line
    else
        rust
        . $HOME/.cargo/env
        line
        echo -e "$GREEN CARGO installed.$NORMAL"
        line
    fi

WASMDEP=$(which wasm-pack)
    if [ -f "$WASMDEP" ]; then
        line
        echo -e "$YELLOW File WASM exist. No need to install.$NORMAL"
        line
    else
        wasm
        line
        echo -e "$GREEN WASM installed.$NORMAL"
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
}
function setupMain {
setup "${1}" "${2}" "${3}" "${4}"
CONF="$HOME/.ironfish/config.json"
if [ -f "$CONF" ]; then
    line
    echo -e "$YELLOW Found an ironfish config. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall ironfish config.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    line
    read -p "Your answer: " ANSWER
    if [ "$ANSWER" == "1" ]; then
        rm -rf $CONF
        config
    elif [ "$ANSWER" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    config
fi

MINER="/etc/systemd/system/ironfish-miner.service"
if [ -f "$MINER" ]; then
    line
    echo -e "$YELLOW Found an ironfish-miner service. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall ironfish-miner service.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    line
    read -p "Your answer: " ANSWER
    if [ "$ANSWER" == "1" ]; then
        rm -rf $MINER
        ironfishMiner
    elif [ "$ANSWER" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    ironfishMiner
    line
    echo -e "$GREEN Ironfish-miner service created.$NORMAL"
    line
fi

IRON="/etc/systemd/system/ironfish.service"
if [ -f "$IRON" ]; then
    line
    echo -e "$YELLOW Found an ironfish service. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall ironfish service.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    line
    read -p "Your answer: " ANSWERS
    if [ "$ANSWERS" == "1" ]; then
        rm -rf $IRON
        ironfish
    elif [ "$ANSWERS" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    ironfish
    line
    echo -e "$GREEN Ironfish service created.$NORMAL"
    line
fi

EXP='export RUN="yarn --cwd $HOME/ironfish/ironfish-cli/ start"'
if grep -R "$EXP" $HOME/.profile; then
    line
    echo -e "$GREEN Ironfish ENV found.$NORMAL"
    line
else
    line
    profiles
    echo -e "$GREEN Ironfish ENV installed.$NORMAL"
    line
fi

PROJECT="$HOME/ironfish"
    if [ -e "$PROJECT" ]; then
        line
        echo -e "$YELLOW Found an $PROJECT directory. Choose an option:$NORMAL"
        echo -e "$RED 1$NORMAL -$YELLOW Rebuild $PROJECT.$NORMAL"
        echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
        line
        read -p "Your answer: " ANSWERSS
        if [ "$ANSWERSS" == "1" ]; then
            sudo systemctl stop ironfish
            sudo systemctl stop ironfish-miner
            rm -rf $PROJECT
            vars
            build
            line
            echo -e "$GREEN Directory $PROJECT installed.$NORMAL"
            line
        elif [ "$ANSWERSS" == "2" ]; then
            line
            echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
            line
        fi
    else
        vars
        build
        line
        echo -e "$GREEN Directory $PROJECT installed.$NORMAL"
        line
    fi
limit
sleep 3
}
function req {
    sudo systemctl restart ironfish
    sudo systemctl restart ironfish-miner
    line
    echo -e "$GREEN IRONFISH CONFIGURED.$NORMAL"
    #echo -e "$YELLOW Type$NORMAL$RED sudo systemctl start ironfish$NORMAL$YELLOW- to start ironfish node.$NORMAL"
    #echo -e "$YELLOW Type$NORMAL$RED sudo systemctl start ironfish-miner$NORMAL$YELLOW- to start ironfish miner.$NORMAL"
    #line
    echo -e "$YELLOW Type$NORMAL$RED sudo journalctl -u ironfish -f --line 100$NORMAL$YELLOW - to see the ironfish node logs.$NORMAL"
    echo -e "$YELLOW Type$NORMAL$RED sudo journalctl -u ironfish-miner -f --line 100$NORMAL$YELLOW - to see the ironfish miner logs.$NORMAL"
    line
    echo -e "$GREEN DONE.$NORMAL"
    line
    sleep 3
}

while getopts ":n:g:t:p:" o; do
  case "${o}" in
    n)
      n=${OPTARG}
      ;;
    g)
      g=${OPTARG}
      ;;
    t)
      t=${OPTARG}
      ;;
    p)
      p=${OPTARG}
      ;;
  esac
done
shift $((OPTIND-1))

components
setupDep
setupMain "${n}" "${g}" "${t}" "${p}"
req
