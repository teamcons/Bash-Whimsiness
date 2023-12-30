#!/bin/bash

echo "PREPARING APFS-Fuse compilation environment"
apt update
apt install libicu-dev bzip2 cmake libz-dev libbz2-dev fuse3 libfuse3-3 libfuse3-dev clang git libattr1-dev

echo "RETRIEVING APFS-Fuse"
git clone https://github.com/sgan81/apfs-fuse.git
cd apfs-fuse
git submodule init
git submodule update


echo "BUILDING APFS-Fuse"
mkdir build
cd build
cmake ..
make
if [ $? -eq 0 ]
then 
	echo "BUILDING SUCCESSFUL"
	sudo fdisk -l
else
	echo "BUILDING FAILED"
fi



echo "MOUNT PHASE : which drive ?"
read devsdx
mkdir -p /media/macos
./apfs-fuse -o allow_other "$devsdx" /media/macos



if [ $? -eq 0 ]
then 
	echo "MOUNTING SUCCESSFUL"
	echo "UNMOUNT : type thrice enter"
	read ; read ; read
	fusermount -u /media/macos
else
	echo "MOUNTING FAILED"
fi
