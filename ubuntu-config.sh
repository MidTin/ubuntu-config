#!/bin/bash

localpath=`pwd`

echo "This script finishes the configuration  automatic, only support Ubuntu."
echo "Please make sure $USER has the privileges of 'sudo'."
 
echo "Input your password please:"
read password
 
echo "Configuration is started..."
codename=`lsb_release -a 2> /dev/null | grep Codename | awk '{ print $2 }'`
echo "Ubuntu Version: $codename"

mkdir -p ~/downloads && cd ~/downloads

# Update apt source
echo "Start to update apt sources..."
echo $password | sudo -S mv /etc/apt/sources.list /etc/apt/sources.list.backup
sudo wget http://mirrors.163.com/.help/sources.list.wily
sudo sed "s/wily/$codename/g" sources.list.wily > sources.list
sudo mv sources.list /etc/apt
rm -f sources.list.wily

sudo apt-get update
sudo apt-get install -y git python-pip bc

echo "Update Finished."
 
echo "Ready to install ZSH"
cd "$localpath"
./zsh-install.sh "$password"

echo "Configuring pip.."
mkdir -p ~/.config/pip
pipconfig="~/.config/pip/pip.conf"
echo "[global]" > "$pipconfig"
echo "index-url=http://pypi.doubanio.com/simple" >> "$pipconfig"
echo "trusted-host=pypi.doubanio.com" >> "$pipconfig"

echo "export PIP_CONFIG_FILE=$pipconfig" >> ~/.bashrc >> ~/.zshrc
source ~/.bashrc

echo "Ready to  configure VIM"
cd "$localpath"
./vim-install.sh "$password"


echo "Start configuring the development env."
sudo pip install virtualenv
sudo pip install virtualenvwrapper

WORKON_HOME="~/envs"
mkdir -p $WORKON_HOME
echo "export $WORKON_HOME" >> ~/.bashrc >> ~/.zshrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc >> ~/.zshrc

source ~/.bashrc

echo "Configuration completed."
