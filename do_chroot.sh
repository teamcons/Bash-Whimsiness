#!/bin/bash



lsblk -f
echo "On what device is the install to rescue ? Enter full path"
read devsdx

echo "MOUNTING $devsdx ON $devsdx"
mkdir -p /rescue
mount $devsdx /rescue
mount --bind /dev /rescue/dev
mount --bind /dev/pts /rescue/dev/pts
mount --bind /proc /rescue/proc
mount --bind /sys /rescue/sys
cp /etc/resolv.conf /rescue/etc/resolv.conf



echo "ENTERING CHROOT : Type enter one to enter chroot. Once finish just type exit" ; read
chroot /rescue /bin/bash

echo "CLEAN UNCHROOT : Type enter thrice to undo chroot"
read ; read ; read
umount /rescue/sys
umount /rescue/proc
umount /rescue/dev/pts
umount /rescue/dev
umount /rescue
mount
echo "All unmounted ?"
