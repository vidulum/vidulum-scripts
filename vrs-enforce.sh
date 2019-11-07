#!/bin/bash

# Download and Run
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/vrs-enforce.sh
# chmod u+x vrs-enforce.sh
# ./vrs-enforce.sh

#Upgrade Node to current release
sudo apt install unzip

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

wget -O .vidulum-params/sprout-groth16.params https://github.com/vidulum/sapling-params/releases/download/sapling/sprout-groth16.params
fi

echo " "

if [ -e ~/.vidulum-params/sapling-spend.params ]
then
echo "Sapling-spend params already present!"
else
echo "Downloading Sapling-spend params"

wget -O .vidulum-params/sapling-spend.params https://github.com/vidulum/sapling-params/releases/download/sapling/sapling-spend.params
fi

echo " "

if [ -e ~/.vidulum-params/sapling-output.params ]
then
echo "Sapling-output params already present!"
else
echo "Downloading Sapling-output params"

wget -O .vidulum-params/sapling-output.params https://github.com/vidulum/sapling-params/releases/download/sapling/sapling-output.params
fi


echo " "
wget -q --show-progress https://github.com/vidulum/vidulum/releases/download/v2.0.2/VDL-Linux.zip

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
#echo "The next line should be  protocolversion:  170009"
#./vidulum-cli getnetworkinfo | grep -i 'protocolversion'
echo "Done"
