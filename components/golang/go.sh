#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/logo.sh | bash

RED="\033[31m"
YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"

function setup {
  version "${1}"
  gopath "${2}"
}

function version {
  VERSION=${1:-"1.17.1"}
}

function gopath {
  GO_PATH=${1:-"/usr/local/go"}
}

function line {
echo "-------------------------------------------------------------------"
}

function components {
    line
    echo -e "$YELLOW Components installing... $NORMAL"
    line
    sudo apt update && sudo apt upgrade -y
    sudo apt-get install build-essential automake autoconf libtool wget libssl-dev git cmake perl tmux ufw gcc unzip zip jq make -y
    sudo apt-get install golang-statik -y
    line
    echo -e "$GREEN Components installed... $NORMAL"
    line
}

function goInstall {
    line
    echo -e "$YELLOW GOLANG ${VERSION} installing... $NORMAL"
    line
    mkdir -p $HOME/tmp
    PACK=go${VERSION}.linux-amd64.tar.gz
    PACK_PATH="$HOME/tmp"
    LINK="https://golang.org/dl/${PACK}"
    echo -e "$YELLOW :: Downloading GO archive...$NORMAL"
    wget -P $PACK_PATH $LINK --quiet --show-progress
    sudo tar -C /usr/local -xzf ${PACK_PATH}/${PACK}
    rm -rf $HOME/tmp
    sudo chmod 755 /usr/local/go
    line
    echo -e "$GREEN GOLANG ${VERSION} instaled... $NORMAL"
    line
}

function env {
    mkdir -p ${GO_PATH}{,/bin,/pkg,/src}
    sudo /bin/bash -c  'echo "export PATH=$PATH:/usr/local/go/bin" > /etc/profile'
    sudo /bin/bash -c  'echo "export GOPATH=$GO_PATH" > $HOME/.profile'
    sudo /bin/bash -c  'echo "export PATH=$GO_PATH/bin:\$PATH" > $HOME/.profile'
    sudo /bin/bash -c  'echo "export GOBIN=$GO_PATH/bin" > $HOME/.profile'
    . /etc/profile
    . $HOME/.profile
    line
    echo -e "$GREEN Env instaled... $NORMAL"
    line
}

function launch {
setup "${1}" "${2}"
components
GO="$(which go)"
GOFMT="$(which gofmt)"
GOVERSION="$($(which go) version)"
if [ -f "$GO" ]; then
    line
    echo -e "$YELLOW Found an ${GOVERSION} in your system. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall Golang.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    line
    read -p "Your answer: " ANSWER
    if [ "$ANSWER" == "1" ]; then
        rm -rf $GO $GOFMT
        goInstall
        env
        GOVERSION="$($(which go) version)"
        line
        echo -e "$GREEN ${GOVERSION} instaled... $NORMAL"
        line
    elif [ "$ANSWER" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    goInstall
    env
    GOVERSION="$($(which go) version)"
    line
    echo -e "$GREEN ${GOVERSION} instaled... $NORMAL"
    line
fi
}

while getopts ":v:p::" o; do
  case "${o}" in
    v)
      v=${OPTARG}
      ;;
    p)
      p=${OPTARG}
      ;;
  esac
done
shift $((OPTIND-1))

launch "${v}" "${p}"
