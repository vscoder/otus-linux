# LVM easy

## Prepare

Set box image to `vscoder/centos-7-5`
```ruby
MACHINES = {
  :lvm => {
        :box_name => "vscoder/centos-7-5",
        :box_version => "1.0",
...
```
Fix `box_version` treatment
```ruby
Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|
  
        config.vm.define boxname do |box|
  
            box.vm.box = boxconfig[:box_name]
            config.vm.box_version = boxconfig[:box_version]
...
```

Get available block devices
```shell
lsblk
```
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
Disks `sdb` and `sdc` are for basic things and snapshots. Disks `sdd` and `sde` are for mirror

```shell
sudo lvmdiskscan
```
```log
  /dev/sda1 [       1.00 GiB] 
  /dev/sda2 [      <9.00 GiB] LVM physical volume
  /dev/sdb  [      10.00 GiB] 
  /dev/sdc  [       2.00 GiB] 
  /dev/sdd  [       1.00 GiB] 
  /dev/sde  [       1.00 GiB] 
  4 disks
  1 partition
  0 LVM physical volume whole disks
  1 LVM physical volume
```

## Create LVM

Create first phisycal volume (PV) on `/dev/sdb`
```shell
sudo pvcreate /dev/sdb
```
```log
  Physical volume "/dev/sdb" successfully created.
```

Create volume group (VG) `otus` on PV `/dev/sdb`
```shell
sudo vgcreate otus /dev/sdb
```
```log
  Volume group "otus" successfully created
```

Create logical volume (LV) `test` on VG `otus` with size 80% of available free space
```shell
sudo lvcreate -l+80%FREE -n test otus
```
```log
  Logical volume "test" created.
```

Display info about VG `otus`
```shell
sudo vgdisplay otus
```
```log
  --- Volume group ---
  VG Name               otus
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <10.00 GiB
  PE Size               4.00 MiB
  Total PE              2559
  Alloc PE / Size       2047 / <8.00 GiB
  Free  PE / Size       512 / 2.00 GiB
  VG UUID               Cbg0WX-CffL-SfWw-9EjU-G9Rl-Xqbe-D9fEZc
```

List VG's PVs
```shell
sudo vgdisplay -v otus | grep -i 'PV NAME'
```
```log
  PV Name               /dev/sdb
```

Get detail info about LV
```shell
sudo lvdisplay /dev/otus/test
```
```log
  --- Logical volume ---
  LV Path                /dev/otus/test
  LV Name                test
  VG Name                otus
  LV UUID                IKQcc5-X2xf-p3MR-WQO0-6Gw8-xv5q-NfmKt8
  LV Write Access        read/write
  LV Creation host, time lvm, 2020-05-29 22:46:35 +0000
  LV Status              available
  # open                 0
  LV Size                <8.00 GiB
  Current LE             2047
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2
```

Get short imfo about VGs
```shell
sudo vgs
```
```log
  VG     #PV #LV #SN Attr   VSize   VFree
  centos   1   2   0 wz--n-  <9.00g    0 
  otus     1   1   0 wz--n- <10.00g 2.00g
```

Get short infog about LVs
```shell
sudo lvs
```
```log
  LV   VG     Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root centos -wi-ao---- <8.00g
  swap centos -wi-ao----  1.00g
  test otus   -wi-a----- <8.00g
```

Create LV `small` with size of `100Mb`
```shell
sudo lvcreate -L100M -n small otus
```
```log
  Logical volume "small" created.
```

## Create FS

Create filesystem (FS) `ext4` on LV `test`
```shell
sudo mkfs.ext4 -L test /dev/otus/test
```
<details><summary>output</summary>
<p>

```log
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=test
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
524288 inodes, 2096128 blocks
104806 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2147483648
64 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
```
</p>
</details>

Mount FS
```shell
sudo mkdir /data
sudo mount /dev/otus/test /data/
mount | grep /data
```
```log
/dev/mapper/otus-test on /data type ext4 (rw,relatime)
```

## Enlarge (extend) LV

Create PV `sdc`
```shell
sudo pvcreate /dev/sdc
```
```log
  Physical volume "/dev/sdc" successfully created.
``` 

Extend VG `otus` on `/dev/sdc`
```shell
sudo vgextend otus /dev/sdc
```
```log
  Volume group "otus" successfully extended
```

Check result
```shell
sudo vgdisplay -v otus | grep -i 'PV Name'
```
```log
  PV Name               /dev/sdb     
  PV Name               /dev/sdc
```
```shell
sudo vgs
```
```log
  VG     #PV #LV #SN Attr   VSize  VFree 
  centos   1   2   0 wz--n- <9.00g     0 
  otus     2   2   0 wz--n- 11.99g <3.90g
```

Emulate LV overflow
```shell
sudo dd if=/dev/zero of=/data/test.log bs=1M count=8000 status=progress
```
```log
8146386944 bytes (8.1 GB) copied, 24.086392 s, 338 MB/s
dd: error writing ‘/data/test.log’: No space left on device
7880+0 records in
7879+0 records out
8262189056 bytes (8.3 GB) copied, 24.5978 s, 336 MB/s
```

And check result
```shell
df -Th /data/
```
```log
Filesystem            Type  Size  Used Avail Use% Mounted on
/dev/mapper/otus-test ext4  7.8G  7.8G     0 100% /data
```

Extend LV to 80% of free space (leave 20% for snapshots)
```shell
sudo lvextend -l+80%FREE /dev/otus/test
```
```log
  Size of logical volume otus/test changed from <8.00 GiB (2047 extents) to <11.12 GiB (2846 extents).
  Logical volume otus/test successfully resized.
```

Check result
```shell
sudo lvs /dev/otus/test
```
```log
  LV   VG   Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  test otus -wi-ao---- <11.12g
```

But FS stays the same (oops...)
```shell
df -Th /data
```
```log
Filesystem            Type  Size  Used Avail Use% Mounted on
/dev/mapper/otus-test ext4  7.8G  7.8G     0 100% /data
```

Let's resize the filesystem
```shell
sudo resize2fs /dev/otus/test
```
```log
resize2fs 1.42.9 (28-Dec-2013)
Filesystem at /dev/otus/test is mounted on /data; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 2
The filesystem on /dev/otus/test is now 2914304 blocks long.
```

Check result
```shell
df -Th /data
```
```log
Filesystem            Type  Size  Used Avail Use% Mounted on
/dev/mapper/otus-test ext4   11G  7.8G  2.6G  76% /data
```


## Reduce LV

Reduce is impossible on mounted FS. So, let's unmount FS
```shell
sudo umount /data/
```
and check FS on errors
```shell
sudo e2fsck -fy /dev/otus/test
```
```log
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
test: 12/729088 files (0.0% non-contiguous), 2105907/2914304 blocks
```

Then we need to reduce FS size
```shell
sudo resize2fs /dev/otus/test 10G
```
```log
resize2fs 1.42.9 (28-Dec-2013)
Resizing the filesystem on /dev/otus/test to 2621440 (4k) blocks.
The filesystem on /dev/otus/test is now 2621440 blocks long.
```

Mount FS and check result
```shell
sudo mount /dev/otus/test /data/
df -Th /data/
```
```log
Filesystem            Type  Size  Used Avail Use% Mounted on
/dev/mapper/otus-test ext4  9.8G  7.8G  1.6G  84% /data
```

And then we can reduce LV size
```shell
sudo lvreduce /dev/otus/test -L 10G
```
```log
  WARNING: Reducing active and open logical volume to 10.00 GiB.
  THIS MAY DESTROY YOUR DATA (filesystem etc.)
Do you really want to reduce otus/test? [y/n]: y
  Size of logical volume otus/test changed from <11.12 GiB (2846 extents) to 10.00 GiB (2560 extents).
  Logical volume otus/test successfully resized.
```

Check LV size after reducing
```shell
sudo lvs /dev/otus/test
```
```log
  LV   VG   Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  test otus -wi-ao---- 10.00g
```

## LVM Snapshot

### Create snapshot

Snapshot can be created by command `lvcreate` with flag `-s`
```shell
sudo lvcreate -L 500M -s -n test-snap /dev/otus/test
```
```log
  Logical volume "test-snap" created.
```

Check result
```shell
sudo vgs -o +lv_size,lv_name | grep test
```
```log
  otus     2   3   1 wz--n- 11.99g <1.41g  10.00g test     
  otus     2   3   1 wz--n- 11.99g <1.41g 500.00m test-snap
```
```shell
lsblk
```
```log
NAME                  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdd                     8:48   0    1G  0 disk 
sdb                     8:16   0   10G  0 disk 
├─otus-test-real      253:4    0   10G  0 lvm  
│ ├─otus-test--snap   253:6    0   10G  0 lvm  
│ └─otus-test         253:2    0   10G  0 lvm  /data
└─otus-small          253:3    0  100M  0 lvm  
sde                     8:64   0    1G  0 disk 
sdc                     8:32   0    2G  0 disk 
├─otus-test-real      253:4    0   10G  0 lvm  
│ ├─otus-test--snap   253:6    0   10G  0 lvm  
│ └─otus-test         253:2    0   10G  0 lvm  /data
└─otus-test--snap-cow 253:5    0  500M  0 lvm  
  └─otus-test--snap   253:6    0   10G  0 lvm  
sda                     8:0    0   10G  0 disk 
├─sda2                  8:2    0    9G  0 part 
│ ├─centos-swap       253:1    0    1G  0 lvm  [SWAP]
│ └─centos-root       253:0    0    8G  0 lvm  /
└─sda1                  8:1    0    1G  0 part /boot
```

### Mount snapshot

Mount snapshot to `/data-snap`
```shell
sudo mkdir /data-snap
sudo mount /dev/otus/test-snap /data-snap/
ll /data-snap/
```
```log
total 8068564
drwx------ 2 root root      16384 May 29 22:55 lost+found
-rw-r--r-- 1 root root 8262189056 May 29 23:05 test.log
```

Unmount snapshot
```shell
sudo umount /data-snap
```

### Revert to snapshot

Remove `test.log` from original disk
```shell
sudo rm /data/test.log
ll /data
```
```log
total 16
drwx------ 2 root root 16384 May 29 22:55 lost+found
```

And do some checks
```shell
df -Th /data
```
```log
Filesystem            Type  Size  Used Avail Use% Mounted on
/dev/mapper/otus-test ext4  9.8G   36M  9.2G   1% /data
```
```shell
sudo pvscan
```
```log
  PV /dev/sda2   VG centos          lvm2 [<9.00 GiB / 0    free]
  PV /dev/sdb    VG otus            lvm2 [<10.00 GiB / 0    free]
  PV /dev/sdc    VG otus            lvm2 [<2.00 GiB / <1.41 GiB free]
  Total: 3 [<20.99 GiB] / in use: 3 [<20.99 GiB] / in no VG: 0 [0   ]
```
```shell
sudo lvscan
```
```log
  ACTIVE            '/dev/centos/swap' [1.00 GiB] inherit
  ACTIVE            '/dev/centos/root' [<8.00 GiB] inherit
  ACTIVE   Original '/dev/otus/test' [10.00 GiB] inherit
  ACTIVE            '/dev/otus/small' [100.00 MiB] inherit
  ACTIVE   Snapshot '/dev/otus/test-snap' [500.00 MiB] inherit
```
```shell
sudo vgdisplay otus
```
```log
  --- Volume group ---
  VG Name               otus
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  8
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               11.99 GiB
  PE Size               4.00 MiB
  Total PE              3070
  Alloc PE / Size       2710 / <10.59 GiB
  Free  PE / Size       360 / <1.41 GiB
  VG UUID               Cbg0WX-CffL-SfWw-9EjU-G9Rl-Xqbe-D9fEZc
```

Do revert!
```shell
sudo umount /data
sudo lvconvert --merge /dev/otus/test-snap
```
```log
  Merging of volume otus/test-snap started.
  otus/test: Merged: 99.94%
  otus/test: Merged: 100.00%
```
and check result
```shell
sudo mount /dev/otus/test /data
ll /data
```
```log
total 8068564
drwx------ 2 root root      16384 May 29 22:55 lost+found
-rw-r--r-- 1 root root 8262189056 May 29 23:05 test.log
```

Check Free PE
```shell
sudo vgdisplay otus
```
```log
  --- Volume group ---
  VG Name               otus
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  11
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               11.99 GiB
  PE Size               4.00 MiB
  Total PE              3070
  Alloc PE / Size       2585 / <10.10 GiB
  Free  PE / Size       485 / 1.89 GiB
  VG UUID               Cbg0WX-CffL-SfWw-9EjU-G9Rl-Xqbe-D9fEZc
```

## LVM Mirroring
