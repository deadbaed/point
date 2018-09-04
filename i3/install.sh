#!/bin/bash
#

echo "install i3 + the tools (see requirements)"

# i3 config
mkdir -p ~/.config/i3/
ln -s ~/point/i3/i3-config ~/.config/i3/config

# i3status config
mkdir -p ~/.config/i3status/
ln -s ~/point/i3/i3status-config ~/.config/i3status/config


echo "config ready";
echo;
echo "restart i3 (*mod + shift + c* if you're just updating the config)";
echo;
echo "wallpaper is at ~/.wallpaper.jpg";
echo "check the file *requirements.txt* to see what to install (most is for arch)";
