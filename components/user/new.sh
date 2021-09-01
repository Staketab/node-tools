#!/bin/bash

read -p "Enter USERNAME": USER

adduser ${USER}
usermod -aG sudo ${USER}
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
echo "DenyUsers ${USER}" | sudo tee -a /etc/ssh/sshd_config
sudo service ssh restart
su - ${USER}
