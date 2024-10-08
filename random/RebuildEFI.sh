#!/bin/bash
# Do all the fixing grub when windows again breaks it
# Chroots are magic
# DO NOT USE, STILL IN HEAVY DEV

##########################
#    PERMISSION CHECK    #
##########################

# If script is not ran as root, sudo itself
if [[ $EUID -ne 0 ]];
then
    echo "$(basename $0) requires root permissions to function"
    exec sudo /bin/bash "$0" "$@"
fi



########################
#    PREPARE CHROOT    #
########################

# WHERE REPAIR
export VOLUME=/dev/nvme0n1
ROOTPARTITION=/dev/nvme0n1p2
EFIPARTITION=/dev/nvme0n1p1

# All needs to be root
mount $ROOTPARTITION /mnt
mount $EFIPARTITION /mnt/boot/efi 

# Mount tools we need for chroot
for i in /dev /dev/pts /proc /sys /run
do
  mount -B $i /mnt$i
done  



########################
#        CHROOT        #
########################


chroot /mnt bash -c '

# Need EFI variables
mount -t efivarfs none /sys/firmware/efi/efivars  

# Set GRUB, exit if all ok
grub-install --target=x86_64-efi  $VOLUME && \
grub-install --recheck  $VOLUME && \
update-grub && exit

' #end of chroot commands




########################
#        CLEANUP       #
########################

# To avoid possible unexpected issues, properly unmount the file systems afterwards.
for i in /run /sys /proc /dev/pts /dev
do
  umount /mnt$i
done  

# Finish cleanly
umount $EFIPARTITION
umount $ROOTPARTITION

