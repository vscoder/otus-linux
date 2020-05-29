#!/bin/bash

set -x
# lsblk before
lsblk
# clean /dev/sda
sudo swapoff -a
sudo vgchange -a n
sudo vgremove centos -y
# Copy partition table from sdb to sda
sudo sfdisk -d /dev/sdb | sudo sfdisk --force /dev/sda
lsblk
sudo parted -s /dev/sda print
# Add disks to the mirrors
sudo mdadm /dev/md0 --add /dev/sda1
sudo mdadm /dev/md1 --add /dev/sda2
cat /proc/mdstat
lsblk
