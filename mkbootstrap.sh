#!/bin/bash


## Create vidulum bootstrap ##

#drop to root dir
cd ~


#if bootstrap exists delete it
if [ -d ~/bootstrap ]

then

sudo rm -r bootstrap

fi


mkdir bootstrap && cd bootstrap


cp -r ~/.vidulum/blocks .
cp -r ~/.vidulum/chainstate .
cp ~/.vidulum/peers.dat .

cd ~

#compress
zip vdl_bootstrap.zip bootstrap


#upload file to hosting service (transfer.sh good for 14 days)
#curl --upload-file ./vdl_bootstrap.tar.gz https://transfer.sh/vdl_bootstrap.tar.gz
