#!/bin/sh
#

rm -rf "$HOME/.config/nvim"
ln -s "$(realpath .)" "$HOME/.config/nvim"
