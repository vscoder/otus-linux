# mdadm

- [mdadm](#mdadm)
  - [Prepare Vagrantfile](#prepare-vagrantfile)
  - [Raid10](#raid10)
    - [Zero superblocks](#zero-superblocks)
    - [Create an array](#create-an-array)
    - [Check status](#check-status)
  - [Create mdadm.conf](#create-mdadmconf)
    - [Get array detail](#get-array-detail)
    - [Create mdadm.conf](#create-mdadmconf-1)
    - [Reboot](#reboot)
  - [Break array](#break-array)
  - [Fix array](#fix-array)
    - [Remove broken disks](#remove-broken-disks)
    - [Add new disks](#add-new-disks)
  - [Create partitions](#create-partitions)
    - [Create GPT partition table](#create-gpt-partition-table)
    - [Create partitions](#create-partitions-1)
    - [Create filesystems](#create-filesystems)

## Prepare Vagrantfile

Use box `vscoder/centos-5-7` with mainline kernel and virtualbox guest additions installed.
Add 2 disks. There is total 6 additional disks now, sized 250Mb each.
```ruby
      :sata5 => {
        :dfile => './sata5.vdi',
        :size => 250, # Megabytes
        :port => 5
      },
      :sata6 => {
        :dfile => './sata6.vdi',
        :size => 250, # Megabytes
        :port => 6
      }
```

## Raid10

### Zero superblocks

Zero superblocks
```bash
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}
```
```log
mdadm: Unrecognised md component device - /dev/sdb
mdadm: Unrecognised md component device - /dev/sdc
mdadm: Unrecognised md component device - /dev/sdd
mdadm: Unrecognised md component device - /dev/sde
mdadm: Unrecognised md component device - /dev/sdf
mdadm: Unrecognised md component device - /dev/sdg
```
It's expected output because of disks are already empty. So there aren't members of any md array.

### Create an array

Let's create Raid10 array
- `-l 10` - raid level (`10`)
- `-n 6` - num devices in an array (`6`)

```bash
sudo mdadm --create --verbose /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g}
```
```log
mdadm: layout defaults to n2
mdadm: layout defaults to n2
mdadm: chunk size defaults to 512K
mdadm: size set to 253952K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```

### Check status

Check array status
```bash
cat /proc/mdstat
```
```log
Personalities : [raid10] 
md0 : active raid10 sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      761856 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU]
      
unused devices: <none>
```

Get array info
```bash
sudo mdadm -D /dev/md0
```
<details><summary>output</summary>
<p>

```log
/dev/md0:
           Version : 1.2
     Creation Time : Tue May 12 23:28:59 2020
        Raid Level : raid10
        Array Size : 761856 (744.00 MiB 780.14 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Tue May 12 23:29:03 2020
             State : clean 
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : ea5fa9e7:c1b3f691:2a008a79:4f154edc
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       1       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg
```
</p>
</details>

## Create mdadm.conf

### Get array detail

```bash
sudo mdadm --detail --scan --verbose
```
```log
ARRAY /dev/md0 level=raid10 num-devices=6 metadata=1.2 name=otuslinux:0 UUID=ea5fa9e7:c1b3f691:2a008a79:4f154edc
   devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdf,/dev/sdg
```

### Create mdadm.conf

```bash
sudo mkdir /etc/mdadm
echo "DEVICE partitions" | sudo tee /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee -a /etc/mdadm/mdadm.conf
cat /etc/mdadm/mdadm.conf
```
```log
DEVICE partitions
ARRAY /dev/md0 level=raid10 num-devices=6 metadata=1.2 name=otuslinux:0 UUID=ea5fa9e7:c1b3f691:2a008a79:4f154edc
```

### Reboot

It's need to do reload for correct work of shared folders
Reboot vagrant instance (on host system)
```bash
vagrant reload
```

Check (on VM)
```bash
cat /proc/mdstat
```
```log
Personalities : [raid10] 
md0 : active raid10 sde[3] sdg[5] sdb[0] sdf[4] sdc[1] sdd[2]
      761856 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU]
      
unused devices: <none>
```

As we can see, the array is fully functional after reboot.

## Break array

Set disk `/dev/sde` failed
```bash
sudo mdadm /dev/md0 --fail /dev/sde
```
```log
mdadm: set /dev/sde faulty in /dev/md0
```

Check
```bash
cat /proc/mdstat
```
```log
Personalities : [raid10] 
md0 : active raid10 sde[3](F) sdg[5] sdb[0] sdf[4] sdc[1] sdd[2]
      761856 blocks super 1.2 512K chunks 2 near-copies [6/5] [UUU_UU]
      
unused devices: <none>
```

Set disk `/dev/sdc` failed
```bash
sudo mdadm /dev/md0 --fail /dev/sdc
```
```log
mdadm: set /dev/sdc faulty in /dev/md0
```

Check
```bash
cat /proc/mdstat
```
```log
Personalities : [raid10] 
md0 : active raid10 sde[3](F) sdg[5] sdb[0] sdf[4] sdc[1](F) sdd[2]
      761856 blocks super 1.2 512K chunks 2 near-copies [6/4] [U_U_UU]
      
unused devices: <none>
```

```shell
sudo mdadm -D /dev/md0
```
<details><summary>output</summary>
<p>

```log
/dev/md0:
           Version : 1.2
     Creation Time : Tue May 12 23:59:31 2020
        Raid Level : raid10
        Array Size : 761856 (744.00 MiB 780.14 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Wed May 13 00:06:54 2020
             State : clean, degraded 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 2
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : 246e16d7:075a4d1d:7abd1076:2764d8e4
            Events : 21

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       -       0        0        1      removed
       2       8       48        2      active sync set-A   /dev/sdd
       -       0        0        3      removed
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg

       1       8       32        -      faulty   /dev/sdc
       3       8       64        -      faulty   /dev/sde
```
</p>
</details>

As we can see, the array is still **active**. That's because of all of failed disks are from the same raid10's set named `set-B`.

## Fix array

### Remove broken disks

Remove a broken disks from the array.
```bash
sudo mdadm /dev/md0 --remove /dev/sdc /dev/sde
```
```log
mdadm: hot removed /dev/sdc from /dev/md0
mdadm: hot removed /dev/sde from /dev/md0
```

Check
```bash
cat /proc/mdstat
```
```log
Personalities : [raid10] 
md0 : active raid10 sdg[5] sdb[0] sdf[4] sdd[2]
      761856 blocks super 1.2 512K chunks 2 near-copies [6/4] [U_U_UU]
      
unused devices: <none>
```
```bash
sudo mdadm -D /dev/md0
```
<details><summary>output</summary>
<p>

```log
/dev/md0:
           Version : 1.2
     Creation Time : Tue May 12 23:59:31 2020
        Raid Level : raid10
        Array Size : 761856 (744.00 MiB 780.14 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 6
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Wed May 13 00:12:44 2020
             State : clean, degraded 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : 246e16d7:075a4d1d:7abd1076:2764d8e4
            Events : 22

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       -       0        0        1      removed
       2       8       48        2      active sync set-A   /dev/sdd
       -       0        0        3      removed
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg
```
</p>
</details>

Add

### Add new disks

Zero new disk's superblocks
```bash
sudo mdadm --zero-superblock --force /dev/sd{c,e}
```

Add new disks to an array
```bash
sudo mdadm /dev/md0 --add /dev/sdc /dev/sde
```
```log
mdadm: added /dev/sdc
mdadm: added /dev/sde
```

Check
```bash
cat /proc/mdstat && sudo mdadm -D /dev/md0
```
<details><summary>output</summary>
<p>

```log
Personalities : [raid10] 
md0 : active raid10 sde[7] sdc[6] sdg[5] sdb[0] sdf[4] sdd[2]
      761856 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU]
      
unused devices: <none>
/dev/md0:
           Version : 1.2
     Creation Time : Tue May 12 23:59:31 2020
        Raid Level : raid10
        Array Size : 761856 (744.00 MiB 780.14 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Wed May 13 00:19:05 2020
             State : clean 
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : 246e16d7:075a4d1d:7abd1076:2764d8e4
            Events : 42

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       7       8       64        1      active sync set-B   /dev/sde
       2       8       48        2      active sync set-A   /dev/sdd
       6       8       32        3      active sync set-B   /dev/sdc
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg
```
</p>
</details>

There isn't rebuilding disks because of ssd under the hood... \_^-^_/

It works fine now))

## Create partitions

### Create GPT partition table

Create partition table
```bash
sudo parted -s /dev/md0 mklabel gpt
```

Check
```bash
sudo fdisk -l /dev/md0
```
<details><summary>output</summary>
<p>

```log
WARNING: fdisk GPT support is currently new, and therefore in an experimental phase. Use at your own discretion.

Disk /dev/md0: 780 MB, 780140544 bytes, 1523712 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 524288 bytes / 1572864 bytes
Disk label type: gpt
Disk identifier: 3D748B46-8D52-40A6-BAB8-5C88340DDE2C


#         Start          End    Size  Type            Name
```
</p>
</details>

There is `Disk label type: gpt`. It's an expected result.

### Create partitions

```bash
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
```

Check
```shell
ls -la /dev/md0*
```
```log
brw-rw---- 1 root disk   9, 0 май 13 00:30 /dev/md0
brw-rw---- 1 root disk 259, 4 май 13 00:30 /dev/md0p1
brw-rw---- 1 root disk 259, 5 май 13 00:30 /dev/md0p2
brw-rw---- 1 root disk 259, 6 май 13 00:30 /dev/md0p3
brw-rw---- 1 root disk 259, 7 май 13 00:30 /dev/md0p4
brw-rw---- 1 root disk 259, 0 май 13 00:30 /dev/md0p5
```

### Create filesystems

Create filesystems
```bash
for i in $(seq 1 5); do sudo mkfs.ext4 -L raid10-$i /dev/md0p$i; done
```
<details><summary>output</summary>
<p>

```log
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=raid10-1
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=512 blocks, Stripe width=1536 blocks
37696 inodes, 150528 blocks
7526 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=33816576
19 block groups
8192 blocks per group, 8192 fragments per group
1984 inodes per group
Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=raid10-2
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=512 blocks, Stripe width=1536 blocks
38152 inodes, 152064 blocks
7603 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=33816576
19 block groups
8192 blocks per group, 8192 fragments per group
2008 inodes per group
Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=raid10-3
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=512 blocks, Stripe width=1536 blocks
38456 inodes, 153600 blocks
7680 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=33816576
19 block groups
8192 blocks per group, 8192 fragments per group
2024 inodes per group
Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=raid10-4
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=512 blocks, Stripe width=1536 blocks
38152 inodes, 152064 blocks
7603 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=33816576
19 block groups
8192 blocks per group, 8192 fragments per group
2008 inodes per group
Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=raid10-5
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=512 blocks, Stripe width=1536 blocks
37696 inodes, 150528 blocks
7526 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=33816576
19 block groups
8192 blocks per group, 8192 fragments per group
1984 inodes per group
Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```
</p>
</details>

Mount filesystems
```bash
# Create catalogs
sudo mkdir -p /raid/part{1,2,3,4,5}
# Mount
for i in $(seq 1 5); do sudo mount /dev/md0p$i /raid/part$i; done
```

Check
```bash
tree /raid
```
```log
/raid
├── part1
│   └── lost+found [error opening dir]
├── part2
│   └── lost+found [error opening dir]
├── part3
│   └── lost+found [error opening dir]
├── part4
│   └── lost+found [error opening dir]
└── part5
    └── lost+found [error opening dir]

10 directories, 0 files
```

```shell
mount | grep /dev/md0
```
```log
/dev/md0p1 on /raid/part1 type ext4 (rw,relatime,stripe=1536)
/dev/md0p2 on /raid/part2 type ext4 (rw,relatime,stripe=1536)
/dev/md0p3 on /raid/part3 type ext4 (rw,relatime,stripe=1536)
/dev/md0p4 on /raid/part4 type ext4 (rw,relatime,stripe=1536)
/dev/md0p5 on /raid/part5 type ext4 (rw,relatime,stripe=1536)
```

Main part of the Home Work is finished.
