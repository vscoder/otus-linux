# Find message from teachers

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
