#!/bin/bash
#

rm ~/.config/i3/config

ln -s ~/point/i3/config ~/.config/i3/config

echo "config ready";
echo "restart i3 (*mod + shift + r* if you're just updating the config)";
echo "";
echo "you need to install:";
echo "i3 xfce4-terminal network-manager-applet gnome-keyring libsecret pactl feh rofi light-git(aur) imgur-screenshot-git(aur)";
