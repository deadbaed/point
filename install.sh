# install.sh
#

echo "Installing mutt and msmtprc for Ubuntu"
sudo apt-get install mutt msmtprc

echo "Copying the configuration file for msmtprc"
cp ./dot-msmtprc ~/.msmtprc

echo "Copying the configuration files for mutt"
cp ./dot-mutt ~/.mutt -r
cp ./dot-muttrc ~/.muttrc
