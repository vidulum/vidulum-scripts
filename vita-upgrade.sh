#!/bin/bash

# Download and Run
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/vita-upgrade.sh
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
echo "Waiting for 15 seconds while daemon stops"
sleep 15

rm vidulumd
rm vidulum-cli

echo " "

if [ -e ~/.vidulum-params/sprout-groth16.params ]
then
echo "Groth 16 Sapling params already present!"
else
echo "Downloading Groth16 Sapling params"

wget -O .vidulum-params/sprout-groth16.params https://downloads.vidulum.app/vidulum/sprout-groth16.params
fi

echo " "

if [ -e ~/.vidulum-params/sapling-spend.params ]
then
echo "Sapling-spend params already present!"
else
echo "Downloading Sapling-spend params"

wget -O .vidulum-params/sapling-spend.params https://downloads.vidulum.app/vidulum/sapling-spend.params
fi

echo " "

if [ -e ~/.vidulum-params/sapling-output.params ]
then
echo "Sapling-output params already present!"
else
echo "Downloading Sapling-output params"

wget -O .vidulum-params/sapling-output.params https://downloads.vidulum.app/vidulum/sapling-output.params
fi


echo " "
wget -q --show-progress https://github.com/vidulum/vidulum/releases/download/v2.0.1/VDL-Linux.zip

echo " "
unzip VDL-Linux.zip

rm VDL-Linux.zip

mv VDL-Linux/vidulum-cli .
mv VDL-Linux/vidulumd .

chmod u+x vidulum-cli
chmod u+x vidulumd

rm -r VDL-Linux

./vidulumd -daemon=1

echo "napping again 10s"
sleep 10

echo " "
echo " "

#Trying too hard
#echo "The next line should be  protocolversion:  170008"
#./vidulum-cli getnetworkinfo | grep -i 'protocolversion'
echo "Done"
