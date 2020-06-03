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


## Find message from teachers

The file was received by command
```shell
zfs send otus/storage@task2 > otus_task2.file
```

Download the file
```shell
cd ~
wget -O otus_task2.file "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"
ll otus_task2.file 
```
```log
-rw-rw-r-- 1 vagrant vagrant 5432736 Jun  3 18:29 otus_task2.file
```

Test ceceiving
```shell
cat otus_task2.file | sudo zfs recv -vnd otus
```
```log
would receive full stream of otus/storage@task2 into otus/storage@task2
```

where
- `-v` - Print verbose information about the stream and the time required to perform the receive operation.
- `-n` - Do not actually receive the stream.
- `-d` - Discard the first element of the sent snapshot's file system name, using the remaining elements to determine the name of the target file system for the new snapshot as described in the paragraph above.

Receive data
```shell
cat otus_task2.file | sudo zfs recv -vd otus
```
```log
receiving full stream of otus/storage@task2 into otus/storage@task2
received 5.18M stream in 3 seconds (1.73M/sec)
```

Check result
```shell
zfs list
```
```log
NAME             USED  AVAIL     REFER  MOUNTPOINT
otus            4.87M   347M       24K  /otus
otus/hometask2  1.80M   347M     1.80M  /otus/hometask2
otus/storage    2.85M   347M     2.83M  /otus/storage
```

Get content of `otus/storage`
```shell
ll /otus/storage
total 2590
-rw-r--r-- 1 root    root          0 May 15 06:46 10M.file
-rw-r--r-- 1 root    root     727040 May 15 07:08 cinderella.tar
-rw-r--r-- 1 root    root         65 May 15 06:39 for_examaple.txt
-rw-r--r-- 1 root    root          0 May 15 06:39 homework4.txt
-rw-r--r-- 1 root    root     309987 May 15 06:39 Limbo.txt
-rw-r--r-- 1 root    root     509836 May 15 06:39 Moby_Dick.txt
drwxr-xr-x 3 vagrant vagrant       4 Dec 18  2017 task1
-rw-r--r-- 1 root    root    1209374 May  6  2016 War_and_Peace.txt
-rw-r--r-- 1 root    root     398635 May 15 06:45 world.sql
```

Find file named `secret_message`
```shell
find /otus/storage -name secret_message
```
```log
/otus/storage/task1/file_mess/secret_message
```

Find file named `secret message` and get it's content
```shell
find /otus/storage -name secret_message -exec cat {} \;
```
```log
https://github.com/sindresorhus/awesome
```

Oh, it's Awesome 8)
