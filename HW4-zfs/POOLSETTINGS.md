# Determine pool settings

All actions executed on clean VM

## Prepare

Install zfs (run on host)
```shell
cat install.sh | vagrant ssh -c "bash"
```

## Get disk image with zfs

### Download and extract

Fetch and extract disk image (download link is modified to download image with `wget` command)
```shell
cd ~
wget -O zfsdisk.img.tar.gz "https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download"
tar xvzf zfsdisk.img.tar.gz
```
```log
zpoolexport/
zpoolexport/filea
zpoolexport/fileb
```

A content of the archive
```shell
cd ~/zpoolexport
ls -l
```
```log
total 1024000
-rw-r--r-- 1 vagrant vagrant 524288000 May 15 05:00 filea
-rw-r--r-- 1 vagrant vagrant 524288000 May 15 05:00 fileb
```

List available pools
```shell
sudo zpool import -d ~/zpoolexport
```
```log
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

        otus                                 ONLINE
          mirror-0                           ONLINE
            /home/vagrant/zpoolexport/filea  ONLINE
            /home/vagrant/zpoolexport/fileb  ONLINE
```

### Mount zfs

Import pool
```shell
sudo zpool import -d ~/zpoolexport otus
sudo zpool list
```
```log
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus   480M  2.18M   478M        -         -     0%     0%  1.00x    ONLINE  -
```

Check content
```shell
tree /otus
```
<details><summary>output</summary>
<p>

```log
/otus/
└── hometask2
    ├── dir1
    │   ├── dir101
    │   ├── dir1010
    │   ├── dir102
    │   ├── dir103
    │   ├── dir104
    │   ├── dir105
    │   ├── dir106
...
        ├── dir92
        ├── dir93
        ├── dir94
        ├── dir95
        ├── dir96
        ├── dir97
        ├── dir98
        └── dir99

17537 directories, 0 files
```
</p>
</details>

All above steps are described in [pool.sh](./pool.sh) and which can be executed via
```shell
cat pool.sh | vagrant ssh -c "bash"
```

## Analyze

Pool size (`480M`)
```shell
zpool get size otus
NAME  PROPERTY  VALUE  SOURCE
otus  size      480M   -
```

ZFS Size (`350M`)
```shell
sudo zfs list
```
```log
NAME             USED  AVAIL     REFER  MOUNTPOINT
otus            1.99M   350M       24K  /otus
otus/hometask2  1.80M   350M     1.80M  /otus/hometask2
```

Pool type (`mirror`)
```shell
zpool status
```
```log
  pool: otus
 state: ONLINE
  scan: none requested
config:

        NAME                                 STATE     READ WRITE CKSUM
        otus                                 ONLINE       0     0     0
          mirror-0                           ONLINE       0     0     0
            /home/vagrant/zpoolexport/filea  ONLINE       0     0     0
            /home/vagrant/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors
```

Recordsize (`128K`)
```shell
zfs get recordsize
```
```log
NAME            PROPERTY    VALUE    SOURCE
otus            recordsize  128K     local
otus/hometask2  recordsize  128K     inherited from otus
```

Compression type (`zle`)
```shell
zfs get compression
```
```log
NAME            PROPERTY     VALUE     SOURCE
otus            compression  zle       local
otus/hometask2  compression  zle       inherited from otus
```

Checksum algorithm (`sha256`)
```shell
zfs get checksum
```
```log
NAME            PROPERTY  VALUE      SOURCE
otus            checksum  sha256     local
otus/hometask2  checksum  sha256     inherited from otus
```

**Settings description** is available in `man 8 zfs` and `man 8 zpool`
