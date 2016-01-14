# install.sh
#

echo "Install packages 'mutt' and 'msmtp'"
echo

echo "Copying the configuration file for msmtprc"
cp ./dot-msmtprc ~/.msmtprc

echo "Copying the configuration files for mutt"
cp ./dot-mutt ~/.mutt -r
cp ./dot-muttrc ~/.muttrc

echo "Now edit the files for the passwords"
echo "Look at app passwords for gmail"
