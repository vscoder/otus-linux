#!/bin/bash

set -x
# lsblk before
sudo lsblk
# Copy partition table from sda to sdb
sfdisk -d /dev/sda | sfdisk --force /dev/sdb
lsblk
parted -s /dev/sdb print
# Set partitions type
parted -s /dev/sdb set 1 "raid" on
parted -s /dev/sdb set 2 "raid" on
parted -s /dev/sdb print
# Zero superblocks
mdadm --zero-superblock /dev/sdb1
mdadm --zero-superblock /dev/sdb2
# Create raid1 mirrors (without first disk)
sudo mdadm --create --force --metadata=1.2 --verbose /dev/md0 --level=1 --raid-disks=2 missing /dev/sdb1
sudo mdadm --create --force --metadata=1.2 --verbose /dev/md1 --level=1 --raid-disks=2 missing /dev/sdb2
cat /proc/mdstat
# Create filesystems
mkfs.ext4 -L boot /dev/md0
mkfs.xfs -L root /dev/md1
# Create mdadm.conf
sudo mkdir /etc/mdadm
echo "DEVICE partitions" | sudo tee /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee -a /etc/mdadm/mdadm.conf
cat /etc/mdadm/mdadm.conf
# Mount filesystems
sudo mkdir /mnt/md{0,1}
sudo mount /dev/md0 /mnt/md0
sudo mount /dev/md1 /mnt/md1
sudo mount | grep /dev/md
# Provide fstab
sudo cp /etc/fstab /etc/fstab.orig
cat <<EOF | sudo tee /etc/fstab
/dev/md0 /boot ext4 defaults 0 0
/dev/md1 /     xfs  defaults 0 0
EOF
cat /etc/fstab
