#!/bin/bash
#
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/swapufw.sh
# chmod u+x swapufw.sh
# ./swapufw.sh
#
echo " "
echo "-------------------------------------------------"
echo "|  This script will install a swapfile,         |"
echo "|  on your VPS so you can squeeze some more     |"
echo "|  memory out of you nodes.                     |"                          
echo "|                                               |"
echo "|  Also, we will setup the UFW firewall on      |"
echo "|  Ubuntu.                                      |"
echo "|                                               |"
echo "|  Please make sure your VPS provider allows    |"  
echo "|  swapfiles. Vultr does, and we recommend them |"
echo "------------------------------------------------|"
echo " "

echo "Would you like to install a swapfile on your VPS? (yes/no)"
read -i "yes" SW       

if [[ $SW =~ [yY](es)* ]]; then

echo "Would you like it to be 2GB or 4GB? (2/4)"
read size

if [ $size == "2" ]; then
SWAP=2048
elif [ $size == "4" ]; then
SWAP=4096
else
exit 1
fi

echo "Creating Swapfile"
sleep 3

dd if=/dev/zero of=/swapfile count="$SWAP" bs=1M

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

echo "/swapfile  none  sw  0  0" >> /etc/fstab

echo "Swapfile installed!"

sleep 3

else
echo " "
echo "We will not be installing a swapfile"
echo " "
fi

echo "Would you like to configure the firewall? (yes/no)"
read -i "yes" FW 

if [[ $FW =~ [yY](es)* ]]; then
sleep 3

echo "Installing Firewall"

apt-get -y install ufw 
ufw allow ssh/tcp
ufw limit ssh/tcp
ufw allow 7676
ufw logging on
ufw reload

echo " "
echo "Firewall is enabled for a Vidulum Node!"

sleep 2

else 

echo "Firewall will not be configured"

fi
