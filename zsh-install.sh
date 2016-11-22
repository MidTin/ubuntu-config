#!/bin/bash

password=$1

if [ "$password" = '' ] 
    then
        echo "Please input your password:"
        read password
fi


echo "Start installing ZSH..." 
sudo -p "$passwod" apt-get install zsh
chsh -s /bin/zsh

echo "Installing oh-my-zsh..."
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


echo "ZSH is ready."
