#!/bin/bash

echo "This script finishes the configuration  automatic, only support Ubuntu."
echo "Please make sure $USER has the privileges of 'sudo'."

echo "Input your password please:"
read password

echo "Configuration is started..."
codename=`lsb_release -a 2> /dev/null | grep Codename | awk '{ print $2 }'`
echo "Ubuntu Version: $codename"

mkdir ~/Downloads && cd ~/Downloads

# Update apt source
echo "Start to update apt sources..."
echo "$password" | sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup
sudo wget http://mirrors.163.com/.help/sources.list.wily
sudo mv sources.list.wily /etc/apt/sources.list
sudo sed 's/wily/$codename/g' /etc/apt/sources.list

sudo apt-get update
sudo apt-get install -y git python-pip

echo "Update Finished."


echo "Ready to  configure VIM"
./vim-install.sh "$password"


echo "Ready to install ZSH"
./zsh-install.sh "$password"


echo "Start configuring the development env."
sudo pip install virtualenv
sudo pip install virtualenvwrapper

WORKON_HOME="~/envs"
mkdir -p $WORKON_HOME
echo "export $WORKON_HOME" >> ~/.bashrc >> ~/.zshrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc >> ~/.zshrc

source ~/.bashrc
