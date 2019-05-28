#!/usr/bin/env bash
#
# Download and Run
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/vnode-install.sh
# chmod u+x vnode-install.sh
# ./vnode-install.sh
#
echo "    ##########################################   "
echo "    ## Downloading and installing bootstrap ##   "
echo "    ##########################################   "
#
wget https://github.com/vidulum/vidulum/releases/download/v1.0.1/vdl_boostrap.zip
#
unzip vdl_boostrap.zip
#
#
echo " "
echo "----------------------------------------------"
echo "| The script will check for important config |"
echo "| files and back them up in your home folder |"
echo "| temporaily while the rest of .vidulum      |"                          
echo "| is deleted so the bootstrap works as it    |"
echo "| should, and then they are moved back after |"
echo "| the bootstrap files are done installing    |"
echo "| Specifically;                              |"  
echo "| wallet.dat, vidulum.conf, masternode.conf  |"
echo "----------------------------------------------"
echo " "
#
if [ -e ~/.vidulum/wallet.dat ]; then
        cp .vidulum/wallet.dat .
else
        echo "No wallet.dat file found"
fi
if [ -e ~/.vidulum/vidulum.conf ]; then
        cp .vidulum/vidulum.conf .
else
        echo "No vidulum.conf file found"
fi
if [ -e ~/.vidulum/masternode.conf ]; then
        cp .vidulum/masternode.conf .
else
        echo "No masternode.conf found"
fi
if [ -d ~/.vidulum ]; then
        rm -rf .vidulum
fi
#
mkdir .vidulum
#
if [ -e ~/wallet.dat ]; then
        mv wallet.dat .vidulum/wallet.dat
else
        echo "No wallet.dat to backup"
fi
if [ -e ~/vidulum.conf ]; then
        mv vidulum.conf .vidulum/vidulum.conf
else
        echo "No vidulum.conf to backup"
fi
if [ -e ~/masternode.conf ]; then
        mv masternode.conf .vidulum/masternode.conf
else
        echo "No masternode.conf to backup"
fi
if [ ! -d ~/.vidulum ]; then
        mkdir .vidulum
else
        echo "Data directory ready and bootstrap is installed!"
fi
# Move Blocks into data directory
cd bootstrap
mv blocks ~/.vidulum/blocks
mv chainstate ~/.vidulum/chainstate
mv peers.dat ~/.vidulum/peers.dat
#
cd ~
# Cleanup
rm -rf bootstrap
rm vdl_boostrap.zip
#
echo " "
echo "    #################################   "
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

if [ "$MN" == "yes" ] || [ "$MN" == "y" ]; then
    echo "Please enter your Masternode Private Key GENKEY: "
    read GENKEY

    echo "Please enter your VPS IP: "
    read VPSIP
fi


echo " "
echo "-----------------------------------------------------------"
echo "| We will now install the dependencies to run your V-Node |"
echo "-----------------------------------------------------------"
apt-get update
sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget bsdmainutils automake curl libgomp1


cd

echo " "
echo " "
echo "|--------------------------------------------|"
echo "|--------------------------------------------|"
echo "| Checking if vidulum-params directory       |"
echo "| exists, if not then it will be created.    |"
echo "|--------------------------------------------|"
echo "|--------------------------------------------|"
echo " "
echo " "

if [ -d ~/.vidulum-params ]
then
echo "------------------------------------"
echo "| Params directory already exists! |"
echo "------------------------------------"

else

echo "---------------------------"
echo "| Making params directory |"
echo "---------------------------"

mkdir .vidulum-params
fi

echo " "
echo " "
echo "|-------------------------------------|"
echo "|-------------------------------------|"
echo "| Checking if sprout keys exist, if   |"
echo "| not they will be downloaded now.    |"
echo "|-------------------------------------|"
echo "|-------------------------------------|"
echo " "
echo " "

if [ -e ~/.vidulum-params/sprout-proving.key ]
then
echo "--------------------------------"
echo "| Proving key already present! |"
echo "--------------------------------"

else

echo "----------------------------------"
echo "| Downloading sprout-proving.key |"
echo "----------------------------------"

wget -O .vidulum-params/sprout-proving.key https://z.cash/downloads/sprout-proving.key
fi

echo " "

if [ -e ~/.vidulum-params/sprout-verifying.key ]
then
echo "----------------------------------"
echo "| Verifying key already present! |"
echo "----------------------------------"

else

echo "------------------------------------"
echo "| Downloading sprout-verifying.key |"
echo "------------------------------------"

wget -O .vidulum-params/sprout-verifying.key https://z.cash/downloads/sprout-verifying.key
fi

echo " "

if [ "$MN" == "yes" ] || [ "$MN" == "y" ]; then
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
echo " "
echo "|-----------------------------------|"
echo "|-----------------------------------|"
echo "| Downloading and unpacking Vidulum |"
echo "| binaries if they are not present. |"
echo "|-----------------------------------|"
echo "|-----------------------------------|"
echo " "
echo " "

if [ -e vidulumd ] && [ -e vidulum-cli ]
then
echo "---------------------------------"
echo "| Vidulum is already installed! |"
echo "---------------------------------"

else

wget https://github.com/vidulum/vidulum/releases/download/v1.0.1/vidulum-linux64.zip
unzip vidulum-linux64.zip
rm vidulum-linux64.zip

chmod u+x vidulum-cli
chmod u+x vidulumd
#cp vidulum-release/vidulumd .
#cp vidulum-release/vidulum-cli .
fi

echo " "
echo " "
echo "|------------------------------------------|"
echo "| Ok, it looks like everything is complete!|"
echo "| The daemon is running in the background. |"
echo "| To check on syncing status, type:        |"
echo "| ./vidulum-cli getinfo                    |"
echo "|                                          |"
echo "| When syncing is complete, start the      |"
echo "| mastenode from the GUI wallet, then type:|"
echo "| ./vidulum-cli masternodedebug            |"
echo "|                                          |"
echo "| If V-Node has been successfully started  |"
echo "| the output will state:                   |"
echo "| Masternode successfully started          |"
echo "|------------------------------------------|"
echo " "
./vidulumd -daemon
