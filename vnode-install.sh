#!/usr/bin/env bash
#
# Download and Run
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/vnode-install.sh
# chmod u+x vnode-install.sh
# ./vnode-install.sh
#
echo " "
echo "    #################################   "
echo "    ## Vidulum Node Install Script ##   "
echo "    #################################   "
echo " "
echo "-------------------------------------------"
echo "| We will help you setup your V-Node      |"
echo "| This script will use the latest release |"
echo "-------------------------------------------"
echo " "

echo "Will this be a MASTERNODE? (yes or no)"
read -i "yes" MN

if [[ $MN =~ [yY](es)* ]]; then
    echo "Please enter your Masternode Private Key GENKEY: "
    read GENKEY

    echo "Please enter your VPS IP: "
    read VPSIP
fi

# echo "Would you like to download a bootstrap? (yes or no)"
# read -i "yes" BS 

# if [[ $MN =~ [yY](es)* ]] && [[ $BS =~ [yY](es)* ]]; then
#         echo " "
# 	echo "Downloading Bootstrap for a V-Node"
#         echo " " 
# 	wget https://downloads.vidulum.app/vidulum/VDL-bootstrap.zip
# elif [[ $MN =~ [yY](es)* ]] && [[ $BS =~ [nN](o)* ]]; then
#         echo " "
# 	echo "Not Downloading Bootstrap, moving on with V-Node Configuration"
#         echo " "
# elif [[ $MN =~ [nN](o)* ]] && [[ $BS =~ [yY](es)* ]]; then
#         echo " "	
# 	echo "Downloading Bootstrap for regular node/wallet"
#         echo " "
# 	wget https://downloads.vidulum.app/vidulum/VDL-bootstrap.zip
# else
#         echo " "
# 	echo "Not Downloading Bootstrap, moving on with setup"
#         echo " "
# fi

echo " "
echo "---------------------------------------------------------"
echo "| We will now install the dependencies to run your node |"
echo "---------------------------------------------------------"
echo " "
apt-get update
sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget bsdmainutils automake curl libgomp1 unzip

# echo " "
# echo "   ##########################   "
# echo "   ## Installing bootstrap ##   "
# echo "   ##########################   "
# echo " "

# if [ -f ~/VDL-bootstrap.zip ]; then
#     echo " "
# 	echo "Upacking Bootstrap"
#     echo " "

#     unzip VDL-bootstrap.zip

# else
# 	echo " "
# 	echo "Nothing to upack, moving forward"
#     echo " "
# fi

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

if [ -e ~/.vidulum/wallet.dat ]; then
    cp .vidulum/wallet.dat .
 else
    echo "No wallet.dat file to backup"
fi
if [ -e ~/.vidulum/vidulum.conf ]; then
    cp .vidulum/vidulum.conf .
else
    echo "No vidulum.conf file to backup"
fi
if [ -e ~/.vidulum/masternode.conf ]; then
    cp .vidulum/masternode.conf .
else
    echo "No masternode.conf file to backup"
fi
if [ -d ~/.vidulum ]; then
    rm -rf .vidulum
fi

mkdir .vidulum

if [ -e ~/wallet.dat ]; then
    mv wallet.dat .vidulum/wallet.dat
else
    echo "No wallet.dat to move back"
fi
if [ -e ~/vidulum.conf ]; then
    mv vidulum.conf .vidulum/vidulum.conf
else
    echo "No vidulum.conf to move back"
fi
if [ -e ~/masternode.conf ]; then
    mv masternode.conf .vidulum/masternode.conf
else
    echo "No masternode.conf to move back"
fi
if [ ! -d ~/.vidulum ]; then
    mkdir .vidulum
else
    echo "Data directory is already prepared!"
fi

# Move Blocks into data directory
# if [ -d ~/blocks ] && [ -d ~/chainstate ] && [ -e ~/peers.dat ]; then
# mv blocks ~/.vidulum/blocks
# mv chainstate ~/.vidulum/chainstate
# mv peers.dat ~/.vidulum/peers.dat
# else
#     echo "No bootstrap files to install"
# fi
# 

cd ~

# Cleanup
# if [ -f ~/VDL-bootstrap.zip ]; then
# rm -rf VDL-bootstrap.zip
# else
#     echo "Nothing to cleanup"
# fi
#
echo " "
echo "|--------------------------------------------|"
echo "| Checking if vidulum-params directory       |"
echo "| exists, if not then it will be created.    |"
echo "|--------------------------------------------|"
echo " "

if [ -d ~/.vidulum-params ]; then

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
echo "|-------------------------------------|"
echo "| Checking if sprout keys exist, if   |"
echo "| not they will be downloaded now.    |"
echo "|-------------------------------------|"
echo " "

if [ -e ~/.vidulum-params/sprout-proving.key ]; then

echo "--------------------------------"
echo "| Proving key already present! |"
echo "--------------------------------"

else

echo "----------------------------------"
echo "| Downloading sprout-proving.key |"
echo "----------------------------------"

wget -O .vidulum-params/sprout-proving.key https://downloads.vidulum.app/vidulum/sprout-proving.key 

fi

echo " "

if [ -e ~/.vidulum-params/sprout-verifying.key ]; then

echo "----------------------------------"
echo "| Verifying key already present! |"
echo "----------------------------------"

else

echo "------------------------------------"
echo "| Downloading sprout-verifying.key |"
echo "------------------------------------"

wget -O .vidulum-params/sprout-verifying.key https://downloads.vidulum.app/vidulum/sprout-verifying.key

fi

echo " "

if [ -e ~/.vidulum-params/sprout-groth16.params ]; then

echo "--------------------------------------------"
echo "| Groth 16 Sapling params already present! |"
echo "--------------------------------------------"

else

echo "--------------------------------------"    
echo "| Downloading Groth16 Sapling params |"
echo "--------------------------------------"

wget -O .vidulum-params/sprout-groth16.params https://downloads.vidulum.app/vidulum/sprout-groth16.params

fi

echo " "

if [ -e ~/.vidulum-params/sapling-spend.params ]; then

echo "-----------------------------------------"    
echo "| Sapling-spend params already present! |"
echo "-----------------------------------------"

else

echo "------------------------------------"
echo "| Downloading Sapling-spend params |"
echo "------------------------------------"

wget -O .vidulum-params/sapling-spend.params https://downloads.vidulum.app/vidulum/sapling-spend.params

fi

echo " "

if [ -e ~/.vidulum-params/sapling-output.params ]; then

echo "------------------------------------------"    
echo "| Sapling-output params already present! |"
echo "------------------------------------------"

else

echo "-------------------------------------"    
echo "| Downloading Sapling-output params |"
echo "-------------------------------------"

wget -O .vidulum-params/sapling-output.params https://downloads.vidulum.app/vidulum/sapling-output.params

fi

echo " "

if [[ $MN =~ [yY](es)* ]]; then
    
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

elif [[ $MN =~ [nN](o)* ]]; then
	configFile=".vidulum/vidulum.conf"

	touch $configFile

    echo "txindex=1" >> $configFile

else 
	echo "vidulum.conf must be configured properly - stopping script" && exit 1
fi

echo " "
echo "|-----------------------------------|"
echo "| Downloading and unpacking Vidulum |"
echo "| binaries if they are not present. |"
echo "|-----------------------------------|"
echo " "

if [ -e vidulumd ] && [ -e vidulum-cli ] && [ -e vidulum-tx ]; then

echo "---------------------------------"
echo "| Vidulum is already installed! |"
echo "---------------------------------"

else

echo "----------------------------------------"
echo "| Installing latest version of daemon! |"
echo "----------------------------------------"

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

fi

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
