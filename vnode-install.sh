#!/usr/bin/env bash

echo "    ## Vidulum Node Install Script ##   "
echo "    #################################   "
echo " "
echo "----------------------------------------"
echo "| We will help you setup your V-Node   |"
echo "| This script will use Vidulum Release |"
echo "----------------------------------------"
echo " "
echo " "

echo "Will this be a MASTERNODE? (yes or no)"
read -i "yes" MN

if [ "$MN" == "yes" ]; then
    echo "Please enter your Masternode Private Key GENKEY: "
    read GENKEY

    echo "Please enter your VPS IP: "
    read VPSIP
fi


echo " "
echo "-----------------------------------------------------------"
echo "| We will now install the dependencies to run your V-Node |"
echo "-----------------------------------------------------------"
sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget bsdmainutils automake curl


cd

echo " "
echo "------------------------------------"
echo "| Making data and params directory |"
echo "------------------------------------"
mkdir .vidulum-params
mkdir .vidulum

echo " "
echo "--------------------"
echo "| Downloading keys |"
echo "--------------------"
wget -O .vidulum-params/sprout-proving.key https://gitlab.com/zcashcommunity/params/raw/master/sprout-proving.key
wget -O .vidulum-params/sprout-verifying.key https://gitlab.com/zcashcommunity/params/raw/master/sprout-verifying.key

if [ "$MN" == "yes" ]; then
    configFile=".vidulum/vidulum.conf"

    touch $configFile
    
    rpcuser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcuser="$rpcuser >> $configFile
    rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcpassword="$rpcpassword >> $configFile
    echo "listen=1" >> $configFile
    echo "server=1" >> $configFile
    echo "txindex=1" >> $configFile
    echo "daemon=1" >> $configFile
    echo "masternodeaddr="$VPSIP":7676" >> $configFile
    echo "externalip="$VPSIP":7676" >> $configFile
    echo "masternodeprivkey="$GENKEY >> $configFile
    echo "masternode=1" >> $configFile
fi


echo " "
echo "-------------------------------------"
echo "| Downloading and unpacking Vidulum |"
echo "-------------------------------------"
wget https://github.com/vidulum/vidulum/releases/download/v1.0.0/vidulum-linux64.tar.gz
tar -xvf vidulum-linux64.tar.gz

echo " "
echo "--------------------------------------------"
echo "| Ok, it looks like everything is complete |"
echo "|                                          |"
echo "| Starting your V-Node to sync the chain   |"
echo "--------------------------------------------"
echo " "
echo "type   ./vidulum-cli getinfo    to see sync status"
./vidulumd
