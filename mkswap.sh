#!/bin/bash
#
# Swapfiles and UFW - for Vidulum users #
echo " "
echo " -------------------------------------------------------------"
echo "  This script will automatically make a swapfile on your vps. "
echo "  Some VPS providers do not allow making swapfiles on their   "
echo "  servers. It is YOUR Responsibilty to check with the rules.  "
echo "  Vidulum recommends Vultr, who is fine with it. This will    "
echo "  allow you to run a node on a $5 VPS as opposed to a $10 one "
echo "--------------------------------------------------------------"
echo " ------------------------------------------------------------ "
echo " Also, this script is going to enable the UFW firewall and    "
echo " and configure it for you. This is assuming you are using     "
echo " an Ubuntu VPS as recommended.                                "
echo "--------------------------------------------------------------"
echo " "

echo "Would you like to create a swapfile? (yes/no)"
read -i "yes" SF 

if [[ $SF =~ [yY](es)* ]]; then
    echo "Do you want a 2GB or 4GB swapfile? (2/4)"
    read SIZE	
fi

if [ $SIZE == "2" ]; then
SWAP=2048
elif [ $SIZE == "4" ]; then
SWAP=4096
else
exit 1

echo "Would you like a firewall to be installed? (yes/no)"
read -i "yes" FW

if [[ $SF =~ [yY](es)* ]] && [[ $FW =~ [yY](es)* ]]; then
	    echo " "
	    echo "Awesome choice, this script will do both!"
        echo " "
elif [[ $SF =~ [yY](es) ]] && [[ $FW =~ [nN](o)* ]]; then        
        echo " "
	    echo "Then we will setup swapfile, with no firewall."
        echo " "
elif [[ $SW =~ [nN](o)* ]] && [[ $FW =~ [yY](es)* ]]; then
	    echo " "
	    echo "No swapfile, but we will setup firewall!"
	    echo " "
else
        echo " "
	    echo "Nothing for you here - exiting script"
	   
	    exit 1
fi

# Making swapfile

echo " "

echo "Okay, lets prepare to install a swapfile on the VPS."

if [[ -e /root/swapfile ]] || [[ ls / | grep swapfile ]]; then 
 	
echo "You already have a swapfile."	
exit 1

fi

if [[ ! -e /root/swapfile ]]; then

dd if=/dev/zero of=/swapfile count=${SWAP} bs=1M

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

echo "/swapfile none swap sw 0 0" >> /etc/fstab

## Swap  done, UFW Firewall next #

if $FW=

then [[ $FW=NP ]]
	apt install ufw
	
	ufw allow ssh/tcp
	
	ufw limit ssh/tcp
	
	ufw allow 7676
	
	ufw logging on
	
	ufw enable
	
	ufw status

# UFW Fireawall is good to good #:wq
