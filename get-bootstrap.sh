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

sudo rm -r ~/.vidulum/blocks
sudo rm -r ~/.vidulum/chainstate

echo " "
echo " "
echo "----------------------------------------------------------"
echo "| Blockchain deleted without touching configs and wallet |"
echo "----------------------------------------------------------"

fi


#Download compressed bootstrap file
echo " "
echo " "
echo "-----------------------------------------"
echo "| Downloading current Vidulum bootstrap |"
echo "-----------------------------------------"

wget https://downloads.vidulum.app/bootstrap.zip


#Decompress
echo " "
echo " "
echo "-------------------------------------------------------"
echo "| Pulling all of the needles out of the new hay stack |"
echo "-------------------------------------------------------"

unzip bootstrap.zip

#Move everything to the Vidulum datadir
echo " "
echo " "
echo "----------------------------------------------"
echo "| Putting new needles into the new hay stack |"
echo "----------------------------------------------"
mv blocks ~/.vidulum/blocks
mv chainstate ~/.vidulum/chainstate

#Clean up
echo " "
echo " "
echo " Removing the hay stack "

rm bootstrap.zip

#Run the wallet and allow it to finish sync
echo " "
echo " "
echo "-----------------------------------------------------"
echo "| You can now start your vidulum daemon  ./vidulumd |"
echo "-----------------------------------------------------"
