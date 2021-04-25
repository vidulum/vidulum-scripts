#!/bin/bash

# Download and Run
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/upgrade-2.2.1.sh
# chmod u+x upgrade-2.2.1.sh
# ./upgrade-2.2.1.sh

#Upgrade Node to current release
sudo apt install unzip

echo " "
echo " "
echo "Upgrading to Vidulum 2.2.1"

echo " "
./vidulum-cli stop

echo " "
echo " "
echo "Waiting for 15 seconds while daemon stops"
sleep 15

rm vidulumd
rm vidulum-cli

if [ -e ~/VDL-Linux.zip ]
then
rm VDL-Linux.zip
echo "Removed old VDL-Linux.zip"
fi

echo " "
wget -q --show-progress https://github.com/vidulum/vidulum/releases/download/2.2.1/VDL-Linux.zip

echo " "
unzip VDL-Linux.zip

rm VDL-Linux.zip

mv VDL-Linux/vidulum-cli .
mv VDL-Linux/vidulumd .
mv VDL-Linux/vidulum-tx .

chmod u+x vidulum-cli
chmod u+x vidulumd
chmod u+x vidulum-tx

rm -r VDL-Linux

./vidulumd -daemon=1

echo "napping again 10s"
sleep 10

echo " "
echo " "

#Trying too hard
#echo "The next line should be  protocolversion:  170011"
#./vidulum-cli getnetworkinfo | grep -i 'protocolversion'
echo "Done"
