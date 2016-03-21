# install.sh
#

echo "Install packages 'mutt', 'msmtp', 'w3m' and 'eog'"
echo

echo "Copying the configuration file for msmtprc"
cp ./dot-msmtprc ~/.msmtprc
chmod 600 ~/.msmtprc

echo "Copying the configuration files for mutt"
cp ./dot-mutt ~/.mutt -r
chmod 700 ~/.mutt/
chmod 600 ~/.mutt/*
cp ./dot-muttrc ~/.muttrc
chmod 600 ~/.muttrc

echo "Now edit the files for the passwords"
echo "Look at app passwords for gmail"
