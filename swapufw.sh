#!/bin/bash
#
#
#
#
echo " "
echo "-------------------------------------------------"
echo "|  This script will install a swapfile,         |"
echo "|  on your VPS so you can squeeze some more     |"
echo "|  memory out of you nodes.                     |"                          
echo "|                                               |"
echo "|  Also, we will setup the UFW firewall on      |"
echo "|  Ubuntu.                                      |"
echo "|  Please make sure your VPS provider allows    |"  
echo "|  swapfiles. Vultr does, and we recommend them |"
echo "------------------------------------------------|"
echo " "

echo "Would you like to install a swapfile on your VPS? (yes/no)"
read -i SW       

if [[ $SW =~ [yY](es)* ]]; then

echo "Would you like it to be 2GB or 4GB? (2/4)"
read -i SIZE

dd if=/dev/zero of=/swapfile count=${SIZE} bs=1M

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

echo "/swapfile  none  sw  0  0" >> /etc/fstab

echo "Swapfile installed!"

sleep 10

else 

echo "We will not be installing a swapfile"
echo " "
fi

echo "Would you like to configure the firewall? (yes/no)"
read -i FW 

if [[ $FW =~ [yY](es)* ]]; then

apt-get -y install ufw 
ufw allow ssh/tcp
ufw limit ssh/tcp
ufw allow 7676
ufw logging on
ufw enable
ufw status

echo " "
echo "Firewall is enabled for a Vidulum Node!"

sleep 10

else 

echo "Firewall will not be configured"

fi
















