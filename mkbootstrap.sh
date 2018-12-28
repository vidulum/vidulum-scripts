#!/bin/bash


## Create vidulum bootstrap ##

#drop to base dir
cd ~


#if folder exists delete it
if [ -d ~/bootstrap ]

then

sudo rm -r bootstrap

fi


#make a folder and slide into it
mkdir bootstrap && cd bootstrap

#use the kodak scanner to copy some stuff
cp -r ~/.vidulum/blocks .
cp -r ~/.vidulum/chainstate .
cp ~/.vidulum/peers.dat .


###REMOVE FOR NOW
#concatenate block data into bootstrap.dat
#cat blk* > bootstrap.dat

#Drop it like its hot
cd ~

#Compress the hay stack
tar -czvf vdl_bootstrap.tar.gz bootstrap


#upload file to hosting service (transfer.sh good for 14 days)
curl --upload-file ./vdl_bootstrap.tar.gz https://transfer.sh/vdl_bootstrap.tar.gz
