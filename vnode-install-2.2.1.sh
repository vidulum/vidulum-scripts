#!/usr/bin/env bash
#
# Download and Run
# REMOVE ANY EXISTING vnode-install-2.X.X.sh SCRIPTS  ( rm vnode-install-2.X.X.sh )
# wget https://raw.githubusercontent.com/vidulum/vidulum-scripts/master/vnode-install-2.2.1.sh
# chmod u+x vnode-install-2.2.1.sh
# ./vnode-install-2.2.1.sh
#
echo " "
echo "    ##################################   "
echo "    ## Vidulum 2.2.1 Install Script ##   "
echo "    ##################################   "
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

echo "Would you like to download a bootstrap? (yes or no)"
read -i "yes" BS 

if [[ $BS =~ [yY](es)* ]]; then
        echo " "
	echo "Downloading Bootstrap for a V-Node"
        echo " " 
	wget https://downloads.vidulum.app/bootstrap.zip
else
        echo " "
	echo "Not Downloading Bootstrap, moving on to next step"
        echo " "
fi

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

echo " "
echo "   ##########################   "
echo "   ## Installing bootstrap ##   "
echo "   ##########################   "
echo " "

if [ -f ~/bootstrap.zip ]; then
  echo " "
  echo "Upacking Bootstrap"
  echo " "
  unzip bootstrap.zip
else
  echo " "
  echo "Nothing to upack, moving forward"
  echo " "
fi

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

if [ -d ~/.vidulum ]; then
    if [ -d ~/.vidulum/blocks ]; then
      rm -r .vidulum/blocks
    fi
    if [ -d ~/.vidulum/chainstate ]; then
      rm -r .vidulum/chainstate
    fi
else
  mkdir .vidulum
fi

#Move Blocks into data directory
if [ -d ~/bootstrap/blocks ] && [ -d ~/bootstrap/chainstate ]; then
  mv blocks ~/.vidulum/blocks
  mv chainstate ~/.vidulum/chainstate
else
    echo "No bootstrap files to install"
fi

cd ~

#Cleanup
if [ -f ~/bootstrap.zip ]; then
rm -rf bootstrap.zip
fi

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

wget -O .vidulum-params/sprout-proving.key https://github.com/vidulum/sapling-params/releases/download/sapling/sprout-proving.key

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

wget -O .vidulum-params/sprout-verifying.key https://github.com/vidulum/sapling-params/releases/download/sapling/sprout-verifying.key

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

wget -O .vidulum-params/sprout-groth16.params https://github.com/vidulum/sapling-params/releases/download/sapling/sprout-groth16.params

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

wget -O .vidulum-params/sapling-spend.params https://github.com/vidulum/sapling-params/releases/download/sapling/sapling-spend.params

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

wget -O .vidulum-params/sapling-output.params https://github.com/vidulum/sapling-params/releases/download/sapling/sapling-output.params

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
    echo "addnode=207.148.8.58" >> $configFile
    echo "addnode=54.39.23.85" >> $configFile
    echo "addnode=51.79.86.4" >> $configFile
    echo "masternodeaddr="$VPSIP":7676" >> $configFile
    echo "externalip="$VPSIP":7676" >> $configFile
    echo "masternodeprivkey="$GENKEY >> $configFile
    echo "masternode=1" >> $configFile

elif [[ $MN =~ [nN](o)* ]]; then
    configFile=".vidulum/vidulum.conf"
    
    touch $configFile

    echo "txindex=1" >> $configFile
    echo "daemon=1" >> $configFile
    rpcuser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcuser="$rpcuser >> $configFile
    rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcpassword="$rpcpassword >> $configFile
    echo "addnode=207.148.8.58" >> $configFile
    echo "addnode=54.39.23.85" >> $configFile
    echo "addnode=51.79.86.4" >> $configFile
    
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

wget -q --show-progress https://github.com/vidulum/vidulum/releases/download/2.2.1/VDL-Linux.zip

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
