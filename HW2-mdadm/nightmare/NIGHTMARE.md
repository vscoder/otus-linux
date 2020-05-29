# Additional task with two asterisks

перенесети работающую систему с одним диском на RAID 1. Даунтайм на загрузку с нового диска предполагается. В качестве проверики принимается вывод команды lsblk до и после и описание хода решения (можно воспользовать утилитой Script).

Migrate working system frome single disk to raid1. Downtime to boot from new disk is allowed. As result can be `lsblk` output. It is also possible to use `script` utility for console logging.

## Vagrantfile

Vagrantfile is presented [here](./Vagrantfile)

Added one (yes-yes, only one) additional disk `sdb` having the same size as `sda` ^_^
```ruby
MACHINES = {
  :otuslinux => {
    # use vagrant box with kernel-ml from elrepo
    # and with VBoxGuestAdditions is installed
    :box_name => "vscoder/centos-7-5",
    :ip_addr => '192.168.12.101',
    :disks => {
      :sata1 => {
        :dfile => './sata1.vdi',
        :size => 10240,
        :port => 1
      }
    }
  },
}
```

## Migrate to md0

lsblk beefore
```shell
NAME            MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sdb               8:16   0  10G  0 disk 
sda               8:0    0  10G  0 disk 
├─sda2            8:2    0   9G  0 part 
│ ├─centos-swap 253:1    0   1G  0 lvm  [SWAP]
│ └─centos-root 253:0    0   8G  0 lvm  /
└─sda1            8:1    0   1G  0 part /boot
```

Provide script to do the migration: [HW2-mdadm/nightmare/scripts/migrate1.sh](HW2-mdadm/nightmare/scripts/migrate1.sh)

Run the script
```shell
cat ./scripts/migrate1.sh | vagrant ssh
```

Script description
- Copy partition table from `/dev/sda` to `/dev/sdb` and change partition types to `raid`
- Create 2 degraded mirrors (with only one disk of two) for partitions `/` and `/boot`
- Create filesystems, ext4 for `/boot` and xfs for `/`
- Generate `/etc/mdadm/mdadm.conf` for disks have the same names after reboot
- Mount `/dev/md1` to `/mnt/newroot` and `/dev/md0` to `/mnt/newroot/boot`
- Rsync current FS to newly mounted partitions
- Mount pseudo filesystems, like `/proc`, `/dev` etc...
- Provide correct `/etc/fstab` for new filesystem
- Rebuild initramfs
- Append `rd.auto=1` to kernel boot args (and supress arg `quiet`)
- Install grub bootloader from new root fs on both `/dev/sda` and `/dev/sdb`
- And set correct kernel to boot with grub

lsblk
```shell
NAME            MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sdb               8:16   0   10G  0 disk  
├─sdb2            8:18   0    9G  0 part  
│ └─md1           9:1    0    9G  0 raid1 /mnt/newroot
└─sdb1            8:17   0    1G  0 part  
  └─md0           9:0    0 1024M  0 raid1 /mnt/newroot/boot
sda               8:0    0   10G  0 disk  
├─sda2            8:2    0    9G  0 part  
│ ├─centos-swap 253:1    0    1G  0 lvm   [SWAP]
│ └─centos-root 253:0    0    8G  0 lvm   /
└─sda1            8:1    0    1G  0 part  /boot
```

Then reboot VM
```shell
vagrant ssh -c "sudo shutdown -r now"
```

lsblk
```shell
NAME            MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sdb               8:16   0   10G  0 disk  
├─sdb2            8:18   0    9G  0 part  
│ └─md1           9:1    0    9G  0 raid1 /
└─sdb1            8:17   0    1G  0 part  
  └─md0           9:0    0 1024M  0 raid1 /boot
sda               8:0    0   10G  0 disk  
├─sda2            8:2    0    9G  0 part  
│ ├─centos-root 253:1    0    8G  0 lvm   
│ └─centos-swap 253:0    0    1G  0 lvm   
└─sda1            8:1    0    1G  0 part
```

And complete migration with commands from [HW2-mdadm/nightmare/scripts/migrate2.sh](HW2-mdadm/nightmare/scripts/migrate2.sh)
```shell
cat ./scripts/migrate2.sh | vagrant ssh
```

Commands description:
- Turn off swap
- Deactivate and remove lvm volume group `centos`
- Copy partition table from `sdb` to `sda`
- Add `sda1` and `sda2` to mirrors

lsblk
```shell
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sdb       8:16   0   10G  0 disk  
├─sdb2    8:18   0    9G  0 part  
│ └─md1   9:1    0    9G  0 raid1 /
└─sdb1    8:17   0    1G  0 part  
  └─md0   9:0    0 1024M  0 raid1 /boot
sda       8:0    0   10G  0 disk  
├─sda2    8:2    0    9G  0 part  
│ └─md1   9:1    0    9G  0 raid1 /
└─sda1    8:1    0    1G  0 part  
  └─md0   9:0    0 1024M  0 raid1 /boot
```
