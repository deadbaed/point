#!/bin/bash
#

echo "creating gpg foler & copying gpg config file"
mkdir ~/.gnupg
cp ./gpg.conf ~/.gnupg/gpg.conf -v
cp ./gpg-agent.conf ~/.gnupg/gpg-agent.conf -v
echo "done"
