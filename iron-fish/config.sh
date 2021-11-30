#!/bin/bash

curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/staketab+ironfish.sh | bash

YELLOW="\033[33m"
GREEN="\033[32m"
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

function envFile {
sudo /bin/bash -c  'echo "TAG=ghcr.io/iron-fish/ironfish:latest
THREAD=\"'${THREADS}'\"
PORT=\"'${PORT}'\"
" > $HOME/.env'
}

function profiles {
echo 'export RUN="docker run --rm --tty --interactive --net=host -v $HOME/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest"' >> $HOME/.profile
. $HOME/.profile
}

function installation {
setup "${1}" "${2}" "${3}" "${4}"
ENV="$HOME/.env"
if [ -f "$ENV" ]; then
    line
    echo -e "$YELLOW Found an ironfish ENV for docker-compose. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall ironfish config.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    read -p "Your answer: " ANSWER
    if [ "$ANSWER" == "1" ]; then
        rm -rf $ENV
        envFile
    elif [ "$ANSWER" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    envFile
    line
    echo -e "$GREEN Ironfish ENV for docker-compose created.$NORMAL"
    line
fi

EXP='export RUN="docker run --rm --tty --interactive --net=host -v $HOME/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest"'
if grep -R "$EXP" $HOME/.profile; then
    line
    echo -e "$GREEN Ironfish ENV found.$NORMAL"
    line
else
    profiles
    line
    echo -e "$GREEN Ironfish ENV installed.$NORMAL"
    line
fi

mkdir -p $HOME/.ironfish/keys
sudo /bin/bash -c  'echo "{
    \"blockGraffiti\": \"'${GRAFFITI}'\",
    \"nodeName\": \"'${NODENAME}'\",
    \"enableSyncing\": \"true\"
}
" > $HOME/.ironfish/config.json'

line
echo -e "$YELLOW Ironfish Config created.$NORMAL"
line

line
echo -e "$GREEN ALL settings and configs created.$NORMAL"
line
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

installation "${n}" "${g}" "${t}" "${p}"
