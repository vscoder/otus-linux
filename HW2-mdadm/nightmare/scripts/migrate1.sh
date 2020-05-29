#!/bin/bash

set -x
# lsblk before
lsblk
# Copy partition table from sda to sdb
sudo sfdisk -d /dev/sda | sudo sfdisk --force /dev/sdb
lsblk
sudo parted -s /dev/sdb print
# Set partitions type
sudo parted -s /dev/sdb set 1 "raid" on
sudo parted -s /dev/sdb set 2 "raid" on
sudo parted -s /dev/sdb print
# Zero superblocks
sudo mdadm --zero-superblock /dev/sdb1
sudo mdadm --zero-superblock /dev/sdb2
# Create raid1 mirrors (without first disk)
sudo mdadm --create --force --metadata=0.9 --verbose /dev/md0 --level=1 --raid-disks=2 missing /dev/sdb1
sudo mdadm --create --force --metadata=0.9 --verbose /dev/md1 --level=1 --raid-disks=2 missing /dev/sdb2
cat /proc/mdstat
# Create filesystems
sudo mkfs.ext4 -L boot /dev/md0
sudo mkfs.xfs -L root /dev/md1
# Create mdadm.conf
sudo mkdir /etc/mdadm
echo "DEVICE partitions" | sudo tee /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee -a /etc/mdadm/mdadm.conf
cat /etc/mdadm/mdadm.conf
# Mount new / filesystems
sudo mkdir /mnt/newroot
sudo mount /dev/md1 /mnt/newroot
sudo mount | grep /dev/md
# Copy rootfs files
sudo rsync -vaxHAX / /mnt/newroot
# Mount new /boot
sudo mount /dev/md0 /mnt/newroot/boot
# Copy boot files to new /boot
sudo rsync -vaxHAX /boot/ /mnt/newroot/boot
# Mount necessary filesystems
sudo mount --types proc /proc /mnt/newroot/proc
sudo mount --rbind /sys /mnt/newroot/sys
sudo mount --make-rslave /mnt/newroot/sys
sudo mount --rbind /dev /mnt/newroot/dev
sudo mount --make-rslave /mnt/newroot/dev

# Provide fstab
sudo cp /mnt/newroot/etc/fstab /mnt/newroot/etc/fstab.orig
cat <<EOF | sudo tee /mnt/newroot/etc/fstab
/dev/md0 /boot ext4 defaults 0 0
/dev/md1 /     xfs  defaults 0 0
EOF
echo Contetn of new fstab
cat /mnt/newroot/etc/fstab

# Rebuilt initramfs
sudo chroot /mnt/newroot /bin/mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
sudo chroot /mnt/newroot /usr/sbin/dracut /boot/initramfs-$(uname -r).img $(uname -r)

# Pass rd.auto=1 to kernel on boot (for mdadm auto build array)
sudo sed -i".bak" 's/quiet/rd.auto=1/g' /mnt/newroot/etc/default/grub

# Configure and install bootloader
sudo chroot /mnt/newroot /sbin/grub2-mkconfig -o /boot/grub2/grub.cfg
sudo chroot /mnt/newroot /sbin/grub2-install --recheck /dev/sda
sudo chroot /mnt/newroot /sbin/grub2-install --recheck /dev/sdb
sudo chroot /mnt/newroot /sbin/grub2-set-default 0

echo First stage is FINISHED. Now uou must reboot the system.
