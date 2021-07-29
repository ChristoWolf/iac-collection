#!/bin/bash

# Somehow needed: https://askubuntu.com/a/1196701.
sudo apt-get install -y dkms

# Based on https://askubuntu.com/a/193632.
ISO_PATH=/home/vagrant/VBoxGuestAdditions.iso
TMP_MOUNT=/tmp/iso
mkdir $TMP_MOUNT
mount -t iso9660 -o loop $ISO_PATH $TMP_MOUNT
$TMP_MOUNT/VBoxLinuxAdditions.run --nox11
umount $TMP_MOUNT
rm -rf $TMP_MOUNT $ISO_PATH