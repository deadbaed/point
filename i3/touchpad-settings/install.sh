sudo pacman -S libinput xf86-input-libinput xorg-xinput
echo "copying the configuration file to '/etc/X11/xorg.conf.d/'";
sudo cp 30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf;
echo "done";