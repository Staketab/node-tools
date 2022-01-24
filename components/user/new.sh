#!/bin/bash

function setup {
  username "${1}"
}

function username {
  USER=${1}
}

function install {
setup "${1}"
adduser ${USER} --disabled-password
usermod -aG sudo ${USER}
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
echo "DenyUsers ${USER}" | sudo tee -a /etc/ssh/sshd_config
sudo service ssh restart
su - ${USER}
}

while getopts ":u:" o; do
  case "${o}" in
    u)
      u=${OPTARG}
      ;;
  esac
done
shift $((OPTIND-1))

install "${u}"
