#!/bin/bash

# Download and Run
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/upgrade-node.sh
# chmod u+x upgrade-node.sh
# ./upgrade-node.sh

#Upgrade Node to current release

echo " "
echo " "
echo "Upgrading Vidulum daemon and client"
echo "V I D U L U M   B L O C K C H A I N"

echo " "
./vidulum-cli stop

echo " "
echo " "
echo "I take a nap"
echo "I take a nap right here for 5 seconds"
sleep 5

rm vidulumd
rm vidulum-cli

echo " "
wget -q --show-progress https://github.com/vidulum/vidulum/releases/download/v1.0.1/vidulum-linux64.tar.gz

echo " "
tar -xzf vidulum-linux64.tar.gz

rm vidulum-linux64.tar.gz
mv vidulum-release/vidulumd .
mv vidulum-release/vidulum-cli .

./vidulumd -daemon=1

echo "napping again 10s"
sleep 10

echo " "
echo " "

#Trying too hard
#echo "The next line should be  protocolversion:  170007"
#./vidulum-cli getnetworkinfo | grep -i 'protocolversion'
echo "Done"
