#!/bin/bash
#

echo "you need to have git in order to install the config files"
git clone https://github.com/altercation/vim-colors-solarized.git --depth=1
mkdir ~/.vim
mkdir ~/.vim/colors
cp ./vim-colors-solarized/colors/solarized.vim ~/.vim/colors
cp ./dot-vimrc ~/.vimrc
rm -rf ./vim-colors-solarized/
echo "done"
