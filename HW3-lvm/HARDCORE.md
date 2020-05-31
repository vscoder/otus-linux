# Hardcore

## Задача

На нашей куче дисков попробовать поставить `btrfs`/`zfs` с кешем, снапшотами - разметить здесь каталог `/opt`

## The task

Try to create `btrfs`/`zfs` with snapshots, cache and mount `/opt` there.

## Decision

ZFS will be discussed in the next lecture. So now we see on `btrfs`.

## Documentation

BTRFS wiki https://btrfs.wiki.kernel.org/index.php/Main_Page

Article https://habr.com/ru/company/veeam/blog/458250/

Some tests http://www.bog.pp.ru/work/btrfs.html

Mount options https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs(5)#MOUNT_OPTIONS

About compression https://btrfs.wiki.kernel.org/index.php/Compression

Some details https://btrfs.wiki.kernel.org/index.php/Gotchas

Gentoo btrfs wiki (also available on Russian) https://wiki.gentoo.org/wiki/Btrfs

## Prepare

Kernel version
```shell
uname -a
```
```log
Linux lvm 5.6.11-1.el7.elrepo.x86_64 #1 SMP Mon May 4 19:40:21 EDT 2020 x86_64 x86_64 x86_64 GNU/Linux
```

---

Ensure necessary kernel options enabled
```shell
cat /boot/config-5.6.11-1.el7.elrepo.x86_64 | egrep "(CONFIG_LIBCRC32C|CONFIG_ZLIB_INFLATE|CONFIG_ZLIB_DEFLATE)"
```
```log
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
```

---

Get available block devices
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

---

Ensure `btrfs-progs` installed
```shell
{
    sudo yum install -y btrfs-progs
    btrfs version
}
```
<details><summary>output</summary>
<p>

```log
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.corbina.net
 * elrepo: ftp.nluug.nl
 * extras: dedic.sh
 * updates: dedic.sh
Package btrfs-progs-4.9.1-1.el7.x86_64 already installed and latest version
Nothing to do
btrfs-progs v4.9.1
```
</p>
</details>


## Create btrfs filesystem

Create fs on `sdb`
```shell
sudo mkfs.btrfs /dev/sdb
```
```log
btrfs-progs v4.9.1
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               523efeaa-c19a-4183-981f-d650c6c6a628
Node size:          16384
Sector size:        4096
Filesystem size:    10.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.00GiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    10.00GiB  /dev/sdb
```

---

Mount FS
```shell
{
    sudo mkdir -p /btrfs
    sudo mount /dev/sdb /btrfs
}
```

Check
```shell
lsblk
```
<details><summary>output</summary>
<p>

```log
NAME            MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sdd               8:48   0   1G  0 disk 
sdb               8:16   0  10G  0 disk /btrfs
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

---

Check allocated space
```shell
sudo btrfs filesystem df /btrfs
```
```log
Data, single: total=8.00MiB, used=256.00KiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=1.00GiB, used=112.00KiB
GlobalReserve, single: total=3.25MiB, used=0.00B
```

## Create subvolume

Create subvolume named `compressed` (but in fact it's not compressed now)
```shell
sudo btrfs subvolume create /btrfs/compressed
```
```log
Create subvolume '/btrfs/compressed'
```

---

List subvolumes
```shell
sudo btrfs subvolume list /btrfs
```
```log
ID 257 gen 8 top level 5 path compressed
```

---

Show subvolume information
```shell
sudo btrfs subvolume show /btrfs/compressed
```
```log
/btrfs/compressed
        Name:                   compressed
        UUID:                   c05824df-4ddd-b349-85fb-c8b21c0d951d
        Parent UUID:            -
        Received UUID:          -
        Creation time:          2020-05-31 11:08:18 +0000
        Subvolume ID:           257
        Generation:             8
        Gen at creation:        8
        Parent ID:              5
        Top level ID:           5
        Flags:                  -
        Snapshot(s):
```

## Compression

### Install compsize to check file compression

Install necessary packages
```shell
sudo yum install -y git btrfs-progs-devel
```

Clone https://github.com/kilobyte/compsize.git
```shell
mkdir ~/src
cd ~/src
git clone https://github.com/kilobyte/compsize.git
cd compsize/
```

Build and install
```shell
make
```
```log
cc -Wall -std=gnu90  -c -o radix-tree.o radix-tree.c
cc -Wall -std=gnu90  -c -o compsize.o compsize.c
cc -Wall -std=gnu90  -o compsize radix-tree.o compsize.o
```
```shell
sudo make install
```
```log
install -Dm755 compsize /usr/bin/compsize
gzip -9n < compsize.8 > /usr/share/man/man8/compsize.8.gz
```

### Play with compression

Make subvolume compressed with `lzo` algorithm
```shell
sudo btrfs property set /btrfs/compressed compression lzo
sudo btrfs property get /btrfs/compressed
```
```log
ro=false
compression=lzo
```
In fact we just set compression flag on directory `/btrfs/compressed`, because in btrfs compression is property of file or directory, not subvolume. It's also possible to enable compression for filesystem globally woth mount option `-o compress`.

---

Ensure `unzip` is installed
```shell
sudo yum install -y unzip
```

---

Create large text file on `/btrfs/compressed`. About test data: http://mattmahoney.net/dc/textdata.html
```shell
{
    cd /btrfs
    sudo wget http://mattmahoney.net/dc/enwik8.zip
    sudo unzip enwik8.zip
    ll enwik8*
}
```
```log
...
-rw-r--r-- 1 root root 100000000 Jun  1  2011 enwik8
-rw-r--r-- 1 root root  36445475 Sep  1  2011 enwik8.zip
```

---

Copy test file to `/btrfs/compressed`
```shell
sudo cp enwik8 /btrfs/compressed/
ll /btrfs/compressed/
```
```log
total 97660
-rw-r--r-- 1 root root 100000000 May 31 12:19 enwik8
```

Check compression ratio
```shell
sudo compsize /btrfs/compressed/enwik8
```
```log
Type       Perc     Disk Usage   Uncompressed Referenced  
TOTAL       68%       65M          95M          95M       
lzo         68%       65M          95M          95M
```

---

## Compare compression algorithms

Create one more subvolume named `subvol`
```shell
sudo btrfs subvolume create /btrfs/subvol1
```
```log
Create subvolume '/btrfs/subvol1'
```

---

Create 4 directories with corresponding compression algorithms
- uncompressed
- zlib
- lzo
- zstd

```shell
{
  sudo mkdir /btrfs/subvol1/{uncompressed,zlib,lzo,zstd}
  sudo btrfs property set /btrfs/subvol1/zlib compression zlib
  sudo btrfs property set /btrfs/subvol1/lzo compression lzo
  sudo btrfs property set /btrfs/subvol1/zstd compression zstd
}
```

---

Place sample data file to corresponding directories
```shell
cd /btrfs/subvol1
{ 
  echo -n "uncompressed"
  time { sudo cp ../enwik8 ./uncompressed/; sync; }
  sleep 1
  echo -n "zlib"
  time { sudo cp ../enwik8 ./zlib/; sync; }
  sleep 1
  echo -n "lzo"
  time { sudo cp ../enwik8 ./lzo/; sync; }
  sleep 1
  echo -n "zstd"
  time { sudo cp ../enwik8 ./zstd/; sync; }
}
```
```log
uncompressed
real    0m0.592s
user    0m0.004s
sys     0m0.165s
zlib
real    0m0.616s
user    0m0.001s
sys     0m0.108s
lzo
real    0m0.522s
user    0m0.002s
sys     0m0.166s
zstd
real    0m0.504s
user    0m0.009s
sys     0m0.107s
```

---

Compare compression ratio
```shell
ls -1 | xargs -I{} sh -c "echo {}; sudo compsize ./{}"
```
```log
lzo
Type       Perc     Disk Usage   Uncompressed Referenced  
TOTAL       68%       65M          95M          95M       
lzo         68%       65M          95M          95M       
uncompressed
Type       Perc     Disk Usage   Uncompressed Referenced  
TOTAL      100%       95M          95M          95M       
none       100%       95M          95M          95M       
zlib
Type       Perc     Disk Usage   Uncompressed Referenced  
TOTAL       42%       40M          95M          95M       
zlib        42%       40M          95M          95M       
zstd
Type       Perc     Disk Usage   Uncompressed Referenced  
TOTAL       40%       38M          95M          95M       
zstd        40%       38M          95M          95M
```

---

Check filesystem space usage
```shell
sudo btrfs filesystem df /btrfs
```
```log
Data, single: total=1.01GiB, used=500.46MiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=1.00GiB, used=1.39MiB
GlobalReserve, single: total=3.25MiB, used=0.00B
```

## Move /opt to btrfs

Install necessary packages
```shell
sudo yum install -y lsof
```

Create volume for opt
```shell
sudo btrfs subvolume create `/btrfs/opt`
```
```log
Create subvolume '/btrfs/opt'
```

Ensure `/opt` haven't opened files
```shell
sudo lsof /opt
```

Move content of `/opt` to `/btrfs/opt`
```shell
sudo mv /opt/* /btrfs/opt/
```

Mount new `/opt`
```shell
sudo mount -t btrfs -o subvol=opt /dev/sdb /opt/
```

Check
```shell
ll /opt
```
```log
total 0
drwxr-xr-x 1 root root 122 May  9 18:19 VBoxGuestAdditions-6.0.20
```

Add entry to fstab
```shell
sudo blkid | grep btrfs | awk '{ print $2 " /opt btrfs defaults,subvol=/opt 0 0" }' | sudo tee -a /etc/fstab 
```
```log
UUID="523efeaa-c19a-4183-981f-d650c6c6a628" /opt btrfs defaults,subvol=/opt 0 0
```

Check
```shell
sudo umount /opt/
sudo mount /opt
ll /opt
```
```log
total 0
drwxr-xr-x 1 root root 122 May  9 18:19 VBoxGuestAdditions-6.0.20
```

Now **reboot** and ensure `/opt` is mounted, and `/btrfs` is not=)

On host
```shell
vagrant reload
```

Check `/opt` and `/btrfs`
```shell
mount | grep /opt
```
```log
/dev/sdb on /opt type btrfs (rw,relatime,space_cache,subvolid=260,subvol=/opt)
```

```shell
mount | grep /btrfs
```
```log
NO OUTPUT HERE
```

Done!
