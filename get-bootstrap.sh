#!/bin/bash

# Download and Run
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/get-bootstrap.sh
# chmod u+x get-bootstrap.sh
# ./get-bootstrap.sh

###################################
## Grab latest vidulum bootstrap ##
###################################

#Function to check for running process
check_process() {
  [ "$1" = "" ]  && return 0
  [ `pgrep -n $1` ] && return 1 || return 0
}


echo " "
echo " "
echo "  ---------------- READ THIS ----------------  "
echo " "
echo "      Grabbing current Vidulum bootstrap       "
echo " "
echo "To do this right we need to delete your vidulum files"
echo " "
echo "We will leave your wallet.dat and config files alone"
echo " "
echo "Are you ok with that? (yes or no)"
read -i "yes" ALLOW

if [ "$ALLOW" == "no" ] || [ "$ALLOW" == "n" ]; then
    echo "Exiting Script..."
    exit 1
fi


#Check if the vidulum daemon is currently running

echo " "
echo " "
echo "Checking for a running Vidulum daemon"
check_process "vidulumd"
[ $? -eq 1 ] && echo "Safely stopping Vidulum daemon" && `cd ~` && `./vidulum-cli stop`

echo " "
echo " "
echo "Discount Double Check"
check_process "vidulumd"
[ $? -eq 1 ] && echo "----ISSUE Vidulum daemon still running, you need to close it first" && exit 1


if [ -d ~/.vidulum ]

then

cp .vidulum/wallet.dat .
cp .vidulum/vidulum.conf .
cp .vidulum/masternode.conf .
sudo rm -r .vidulum
mkdir .vidulum
mv wallet.dat .vidulum/wallet.dat
mv vidulum.conf .vidulum/vidulum.conf
mv masternode.conf .vidulum/masternode.conf

echo " "
echo " "
echo "----------------------------------------------"
echo "| Files deleted while saving conf and wallet |"
echo "----------------------------------------------"

fi


#Download compressed bootstrap file
echo " "
echo " "
echo "-----------------------------------------"
echo "| Downloading current Vidulum bootstrap |"
echo "-----------------------------------------"

curl https://transfer.sh/10mP4d/vdl_bootstrap.tar.gz -o vdl_bootstrap.tar.gz


#Decompress
echo " "
echo " "
echo "-------------------------------------------------------"
echo "| Pulling all of the needles out of the new hay stack |"
echo "-------------------------------------------------------"
tar -xzf vdl_bootstrap.tar.gz


#Move everything to the Vidulum datadir
echo " "
echo " "
echo "----------------------------------------------"
echo "| Putting new needles into the new hay stack |"
echo "----------------------------------------------"
mv bootstrap/blocks ~/.vidulum/blocks
mv bootstrap/chainstate ~/.vidulum/chainstate
mv bootstrap/peers.dat ~/.vidulum/peers.dat

#Clean up
echo " "
echo " "
echo " Removing the hay stack "
rm vdl_bootstrap.tar.gz


#Run the wallet and allow it to finish sync
echo " "
echo " "
echo "-----------------------------------------------------"
echo "| You can now start your vidulum daemon  ./vidulumd |"
echo "-----------------------------------------------------"
