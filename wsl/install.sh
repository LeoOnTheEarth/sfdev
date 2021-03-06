#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"

if [ ! -f ~/.ansible.cfg ]
then
  cp -f "${SCRIPT_DIR}/ansible.cfg" ~/.ansible.cfg
fi;

if [ ! -f /etc/wsl.conf ]
then
  sudo cp -f "${SCRIPT_DIR}/templates/wsl.conf" /etc/wsl.conf
fi;

# Install Ansible
if [ ! -f /usr/local/bin/ansible ]
then
  sudo apt update
  sudo apt upgrade -y

  # Installing Ansible
  sudo apt install -y python3-pip
  sudo pip3 install ansible
fi;

ansible-playbook "${SCRIPT_DIR}/install.yml" -K -v --extra-vars "@${SCRIPT_DIR}/.wsl-variables.json"
