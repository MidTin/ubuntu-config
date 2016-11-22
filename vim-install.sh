#!/bin/bash

password=$1

if [ "$password" = '' ] 
    then
        echo "Please input your password:"
        read password
fi


# Upgrade the Vim
echo "Installing the newest version VIM.."
echo $password | sudo -S apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git


sysversion=`lsb_release -a 2> /dev/null | grep Release | awk '{ print $2 }'`

if [ $(echo "${sysversion} <= 12.04" | bc) -eq 1 ]
    then
        sudo apt-get remove -y vim-tiny vim-common vim-gui-common vim-nox
else
    sudo apt-get remove -y vim vim-runtime gvim
fi


function getPyConfig() {
    version=$1
    libpath="/usr/lib"
    pyVersion=`ls $libpath | grep python$version\.`
    pyVersionNum=${pyVersion#python}

    echo $pyVersionNum

    if [[ $(echo "${pyVersionNum} < 3.0" | bc) -eq 1 ]]
    then
        echo "$libpath/$pyVersion/config-x86_64-linux-gnu"
    else
        echo "$libpath/$pyVersion/config-$pyVersionNum-x86_64_linux-gun"
    fi
}

py2config=`getPyConfig 2`
py3config=`getPyConfig 3`

cd ~
git clone https://github.com/vim/vim.git

cd vim
./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir="$py2config" \
    --enable-python3interp=yes \
    --with-python3-config-dir="$py3config" \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-gui=gtk2 --enable-cscope --prefix=/usr

make VIMRUNTIMEDIR=/usr/share/vim/vim80
sudo make install

# Set vim as default editor
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim

echo "VIM install finished."

echo "Start configuring VIM..."
git clone https://github.com/MidTin/vim vim-config
cp vim-config/vim/.vimrc ~/

# Install Vundle
echo "Installing Vundle.."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Start installing some packages we need."
sudo apt-get install -y build-essential cmake ctags python-pip
sudo pip install pylama

# Install Nodejs for js syntax completer
cd ~/Downloads
wget https://nodejs.org/dist/v6.9.1/node-v6.9.1.tar.gz
tar -xvf node-v6.9.1.tar.gz

cd node-v6.9.1
./configure
make
sudo make install


# Install plugins
vim -c ":PluginInstall"

# Compile the component of YCM
cd ~/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
./install.py --clang-completer --tern-completer

echo "VIM is ready."







