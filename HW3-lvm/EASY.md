# Easy

## Задание

1. Уменьшить том под / до 8G
1. Выделить том под /home
1. Выделить том под /var - сделать в mirror
1. /home - сделать том для снапшотов
1. Прописать монтирование в fstab. Попробовать с разными опциями и разными файловыми системами ( на выбор)

Работа со снапшотами:
- сгенерить файлы в /home/
- снять снапшот
- удалить часть файлов
- восстановится со снапшота
- залоггировать работу можно с помощья утилиты script
- *на нашей куче дисков попробовать поставить `btrfs`/`zfs` с кешем, снапшотами - разметить здесь каталог `/opt`

## Task

1. Reduce volume to 8Gb
2. Create new volume for `/home`
3. Create new volume for `/var/`
4. Make snapshot for `/home`
5. Provide correct `/etc/fstab`

Work with snapshots
- generate many files in `/home`
- make snapshot
- remove some files
- restore from snapshot
- it's possible to log process with `script` utility
- *try to create `btrfs`/`zfs` with snapshots, cache and mount `/opt` there.

## Recreate VM

On host
```shell
vagrant destroy
vagrant up
vagrant ssh
```

Display block devices
```shell
lsblk
```
<details><summary>output</summary>
<p>

```log
NAME            MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sdd               8:48   0   1G  0 disk 
sdb               8:16   0  10G  0 disk 
sde               8:64   0   1G  0 disk 
sdc               8:32   0   2G  0 disk 
sda               8:0    0  10G  0 disk 
├─sda2            8:2    0   9G  0 part 
│ ├─centos-swap 253:1    0   1G  0 lvm  [SWAP]
│ └─centos-root 253:0    0   8G  0 lvm  /
└─sda1            8:1    0   1G  0 part /boot
```
</p>
</details>

## Reduce root size

Ensure `xfsdump` is installed
```shell
sudo yum install xfsdump
```

Create temporary LV for `/`
```shell
sudo pvcreate /dev/sdb
sudo vgcreate vg_root /dev/sdb
sudo lvcreate -n lv_root -l +100%FREE /dev/vg_root
```
<details><summary>output</summary>
<p>

```log
  Physical volume "/dev/sdb" successfully created.
  Volume group "vg_root" successfully created
  Logical volume "lv_root" created.
```
</p>
</details>

Create ad mount FS
```shell
sudo mkfs.xfs -Lnewroot /dev/vg_root/lv_root
sudo mount /dev/vg_root/lv_root /mnt
```
<details><summary>output</summary>
<p>

```log
meta-data=/dev/vg_root/lv_root   isize=512    agcount=4, agsize=655104 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2620416, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```
</p>
</details>


Copy data from `/` to newly created volume (`/mnt`)
```shell
sudo xfsdump -J - /dev/centos/root | sudo xfsrestore -J - /mnt
```
<details><summary>output</summary>
<p>

```log
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0)
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsdump: level 0 dump of lvm:/
xfsdump: dump date: Sat May 30 15:53:29 2020
xfsdump: session id: 0054af76-6cf9-43d7-b52a-ba26bb1042f2
xfsdump: session label: ""
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 1891232896 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description: 
xfsrestore: hostname: lvm
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/centos-root
xfsrestore: session time: Sat May 30 15:53:29 2020
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: cf2dee09-118d-4e36-9f48-66e49cc57111
xfsrestore: session id: 0054af76-6cf9-43d7-b52a-ba26bb1042f2
xfsrestore: media id: 6aae82fc-cf5c-4eb3-936b-f5fcd47fbb87
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 11365 directories and 64519 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 1815105824 bytes
xfsdump: dump size (non-dir files) : 1791815640 bytes
xfsdump: dump complete: 17 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 17 seconds elapsed
xfsrestore: Restore Status: SUCCESS
```
</p>
</details>

where
- `xfsdump`
  `-J Inhibits the normal update of the inventory.  This is useful when the media being dumped to will be discarded or overwritten.`
- `xfsrestore`
  `-J Inhibits inventory update when on-media session inventory encountered during restore.  xfsrestore opportunistically updates the online  inventory when it encounters an on-media session inventory, but only if run with an effective user id of root and only if this option is not given.`

Ooh, it's **much faster** than `rsync`! =)

## Make new root bootable

Next step is making new root bootable

First chroot into new root
```shell
# mount pseudo filesystems
for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done
sudo chroot /mnt /bin/bash
```
After these steps, we become `root` privileges into newly created filesystem with root at `/mnt`. So, all next commands doesn't need to do with `sudo`.

Generate new grub config
```shell
grub2-mkconfig -o /boot/grub2/grub.cfg
```
```log
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.6.11-1.el7.elrepo.x86_64
Found initrd image: /boot/initramfs-5.6.11-1.el7.elrepo.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-1127.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1127.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-db529269582b41d89d3f9aed34b3ff97
Found initrd image: /boot/initramfs-0-rescue-db529269582b41d89d3f9aed34b3ff97.img
done
```

Update initrd
```shell
set -x
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
set +x
```
[output](./logs/dracut1.log)

Update grub config to boot the system from the correct root partition.
`vi /boot/grub2/grub.cfg`
and run vi command
```vi
:%s#rd.lvm.lv=centos/root#rd.lvm.lv=vg_root/lv_root#g
:wq
```

Check boot order
```shell
sudo awk -F\' '/menuentry / {print $2}' /boot/grub2/grub.cfg
```
```log
CentOS Linux (5.6.11-1.el7.elrepo.x86_64) 7 (Core)
CentOS Linux (3.10.0-1127.el7.x86_64) 7 (Core)
CentOS Linux (0-rescue-db529269582b41d89d3f9aed34b3ff97) 7 (Core)
```
and set default boot entry
```shell
grub2-set-default 0
```

Reboot

Ensure VM rebooted with new root
```shell
lsblk
```
```log
NAME              MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sdd                 8:48   0   1G  0 disk 
sdb                 8:16   0  10G  0 disk 
└─vg_root-lv_root 253:0    0  10G  0 lvm  /
sde                 8:64   0   1G  0 disk 
sdc                 8:32   0   2G  0 disk 
sda                 8:0    0  10G  0 disk 
├─sda2              8:2    0   9G  0 part 
│ ├─centos-swap   253:1    0   1G  0 lvm  [SWAP]
│ └─centos-root   253:2    0   8G  0 lvm  
└─sda1              8:1    0   1G  0 part /boot
```
That is!

Now we need to reduce old root size. 

## Reduce old root size

Remove old root LV
```shell
sudo lvremove -y /dev/centos/root
```
```log
Do you really want to remove active logical volume centos/root? [y/n]: y
  Logical volume "root" successfully removed
```

And create a smaller one (6Gb, not 8=)
```shell
sudo lvcreate -y -n root -L 6G centos
```
```log
  Logical volume "root" created.
```

Check it
```shell
sudo lvscan
```
```log
  ACTIVE            '/dev/centos/swap' [1.00 GiB] inherit
  ACTIVE            '/dev/centos/root' [6.00 GiB] inherit
  ACTIVE            '/dev/vg_root/lv_root' [<10.00 GiB] inherit
```

Create filesystem
```shell
sudo mkfs.xfs -L smallroot /dev/centos/root
```
<details><summary>output</summary>
<p>

```log
meta-data=/dev/centos/root       isize=512    agcount=4, agsize=393216 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=1572864, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```
</p>
</details>

Mount reduced root volume to `/mnt` and migrate fs from temporary root partition
```shell
sudo mount /dev/centos/root /mnt
sudo xfsdump -J - /dev/vg_root/lv_root | sudo xfsrestore -J - /mnt
```
<details><summary>output</summary>
<p>

```log
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0)
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsdump: level 0 dump of lvm:/
xfsdump: dump date: Sat May 30 17:47:58 2020
xfsdump: session id: cfe14576-91f0-4840-bec1-f882d6af4910
xfsdump: session label: ""
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 1889855744 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description: 
xfsrestore: hostname: lvm
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/vg_root-lv_root
xfsrestore: session time: Sat May 30 17:47:58 2020
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: 90fd31f7-964a-4ae1-ba9a-f3a03cccc599
xfsrestore: session id: cfe14576-91f0-4840-bec1-f882d6af4910
xfsrestore: media id: f0ec9804-fc06-4084-bb16-f43e5abd8fe7
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 11369 directories and 64529 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 1813800032 bytes
xfsdump: dump size (non-dir files) : 1790506488 bytes
xfsdump: dump complete: 23 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 24 seconds elapsed
xfsrestore: Restore Status: SUCCESS
```
</p>
</details>

Generate grub config
```shell
for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done
sudo chroot /mnt grub2-mkconfig -o /boot/grub2/grub.cfg
```
<details><summary>output</summary>
<p>

```log
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.6.11-1.el7.elrepo.x86_64
Found initrd image: /boot/initramfs-5.6.11-1.el7.elrepo.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-1127.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1127.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-db529269582b41d89d3f9aed34b3ff97
Found initrd image: /boot/initramfs-0-rescue-db529269582b41d89d3f9aed34b3ff97.img
done
```
</p>
</details>

Regenerate initrd
```shell
cd /mnt/boot ; for i in `ls initramfs-*img`; do sudo chroot /mnt /usr/bin/dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
```
[output](./logs/dracut2.log)

## Move /var to mirrored LV

Install rsync
```shell
sudo yum install -y rsync
```

Prepare new LV for `/var` and mount it to `/newvar`
```shell
{
    sudo pvcreate /dev/sdc /dev/sdd;
    sudo vgcreate vg_var /dev/sdc /dev/sdd;
    sudo lvcreate -L 950M -m1 -n lv_var vg_var;
    sudo mkfs.ext4 /dev/vg_var/lv_var;
    sudo mkdir /newvar;
    sudo mount /dev/vg_var/lv_var /newvar;
}
```
<details><summary>output</summary>
<p>

```log
  Physical volume "/dev/sdc" successfully created.
  Physical volume "/dev/sdd" successfully created.
  Volume group "vg_var" successfully created
  Rounding up size to full physical extent 952.00 MiB
  Logical volume "lv_var" created.
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
60928 inodes, 243712 blocks
12185 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=249561088
8 block groups
32768 blocks per group, 32768 fragments per group
7616 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```
</p>
</details>

Copy data from old `/var` to `/newvar`
```shell
sudo rsync -avHPSAX /mnt/var/ /newvar
```
<details><summary>output</summary>
<p>

```log
spool/postfix/saved/
spool/postfix/trace/
tmp/
tmp/systemd-private-7d9a8c16611d40c3b7e92526e1e6ab00-chronyd.service-wo2FBv/
tmp/systemd-private-7d9a8c16611d40c3b7e92526e1e6ab00-chronyd.service-wo2FBv/tmp/
tmp/systemd-private-d7c729bc1b294c35ba9c1cfd7b7328ef-chronyd.service-bMRqND/
tmp/systemd-private-d7c729bc1b294c35ba9c1cfd7b7328ef-chronyd.service-bMRqND/tmp/
tmp/yum-root-IiYUxB/
tmp/yum-root-IiYUxB/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
          8,656 100%   15.65kB/s    0:00:00 (xfr#1484, to-chk=0/4823)
yp/

sent 164,049,213 bytes  received 305,164 bytes  109,569,584.67 bytes/sec
total size is 163,533,993  speedup is 1.00
```
</p>
</details>

Make backup of `/var`
```shell
sudo mkdir /tmp/oldvar && sudo mv /mnt/var/* /tmp/oldvar
```


Mount `/newvar` to `/mnt/var`
```shell
{
    sudo umount /newvar;
    sudo mount /dev/vg_var/lv_var /mnt/var;
}
```

Update fstab (don't forget about `--append` with `tee`)
```shell
echo "`sudo blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" | sudo tee --append /mnt/etc/fstab
```
```log
UUID="59f493ce-12bb-471e-b56e-e6b2b849060f" /var ext4 defaults 0 0
```

Reboot!!!

And check result
```shell
lsblk
```
```log
NAME                     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdd                        8:48   0    1G  0 disk 
├─vg_var-lv_var_rimage_1 253:6    0  952M  0 lvm  
│ └─vg_var-lv_var        253:7    0  952M  0 lvm  /var
└─vg_var-lv_var_rmeta_1  253:5    0    4M  0 lvm  
  └─vg_var-lv_var        253:7    0  952M  0 lvm  /var
sdb                        8:16   0   10G  0 disk 
└─vg_root-lv_root        253:2    0   10G  0 lvm  
sde                        8:64   0    1G  0 disk 
sdc                        8:32   0    2G  0 disk 
├─vg_var-lv_var_rimage_0 253:4    0  952M  0 lvm  
│ └─vg_var-lv_var        253:7    0  952M  0 lvm  /var
└─vg_var-lv_var_rmeta_0  253:3    0    4M  0 lvm  
  └─vg_var-lv_var        253:7    0  952M  0 lvm  /var
sda                        8:0    0   10G  0 disk 
├─sda2                     8:2    0    9G  0 part 
│ ├─centos-swap          253:1    0    1G  0 lvm  [SWAP]
│ └─centos-root          253:0    0    6G  0 lvm  /
└─sda1                     8:1    0    1G  0 part /boot
```
```shell
df -h
```
```log
Filesystem                 Size  Used Avail Use% Mounted on
devtmpfs                   101M     0  101M   0% /dev
tmpfs                      114M     0  114M   0% /dev/shm
tmpfs                      114M  4.5M  109M   4% /run
tmpfs                      114M     0  114M   0% /sys/fs/cgroup
/dev/mapper/centos-root    6.0G  1.8G  4.3G  29% /
/dev/sda1                 1014M  129M  886M  13% /boot
/dev/mapper/vg_var-lv_var  922M  167M  692M  20% /var
vagrant                    116G  100G   17G  86% /vagrant
tmpfs                       23M     0   23M   0% /run/user/1000
```

Remove temporary LV, VG and PV
```shell
{
    sudo lvremove -y /dev/vg_root/lv_root;
    sudo vgremove -y /dev/vg_root;
    sudo pvremove -y /dev/sdb;
}
```
<details><summary>output</summary>
<p>

```log
  Logical volume "lv_root" successfully removed
  Volume group "vg_root" successfully removed
  Labels on physical volume "/dev/sdb" successfully wiped.
```
</p>
</details>

Done!

## Home snapshots

Move home to separate LV
```shell
{
    sudo lvcreate -n lv_home -L 1G centos;
    sudo mkfs.xfs -L home /dev/centos/lv_home;
    sudo mount /dev/centos/lv_home /mnt;
    sudo cp -aR /home/* /mnt/ && \
    sudo rm -rf /home/*;
    sudo umount /mnt;
    sudo mount /dev/centos/lv_home /home;
}
```

Update fstab
```shell
echo "`sudo blkid | grep home: | awk '{print $3}'` /home xfs defaults 0 0" | sudo tee --append /etc/fstab
```
```log
UUID="cf0c49f5-5188-447e-80c5-a879482eb791" /home xfs defaults 0 0
```

## Test home snapshot

Create files
```shell
sudo touch /home/file{1..20}
```

Create snapshot
```shell
sudo lvcreate -L 100MB -s -n home_snap /dev/centos/lv_home
```
```log
  Logical volume "home_snap" created.
```
and check
```shell
ls /home
```
```log
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
```

Remove files and check
```shell
sudo rm -f /home/file{11..20}
ls /home
```
```log
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9  vagrant
```

## Restore home from snapshot

```shell
{
    sudo umount /home;
    sudo lvconvert --merge /dev/centos/home_snap;
    sudo mount /home;
    ls /home;
}
```
```log
  Merging of volume centos/home_snap started.
  centos/lv_home: Merged: 100.00%
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
```

Done!
