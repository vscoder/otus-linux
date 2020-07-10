# psax.sh

The script [psax.sh](./psax.sh) parses content of `/proc` filesystem and print info about precesses by theirs PIDs.

## Output description

### PID

Display process's identifier

### TTY

Display TTY device path (using command `tty`), or:
- **`-`** if process hasn't FD `0`
- **`?`** if there is an error when try to get TTY device path

### STAT

The first character may be one of
- **`D`** - uninterruptible sleep (usually IO)
- **`R`** - running or runnable (on run queue)
- **`S`** - interruptible sleep (waiting for an event to complete)
- **`T`** - stopped by job control signal
- **`t`** - stopped by debugger during the tracing
- **`W`** - paging (not valid since the 2.6.xx kernel)
- **`X`** - dead (should never be seen)
- **`Z`** - defunct ("zombie") process, terminated but not reaped by its parent

Next may be one or many of characters
- **`<`**    high-priority (not nice to other users)
- **`N`**    low-priority (nice to other users)
- **`s`**    is a session leader
- **`l`**    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
- **`+`**    is in the foreground process group

### TIME

Accumulated cpu time, user + system.

### COMMAND

Display full command with args.

## Notes

The script has custom signals handler for SIG_INT and SIG_TERM using `trap` command. It can be overriden in function `terminate {...}`.

The signals list is available with command `kill -l` 

## Run in vagrant

Login to vagrant instance
```shell
vagrant up
vagrant ssh
```

And run script
```shell
cd /vagrant
./psax.sh
```
```log
  PID TTY        STAT     TIME COMMAND
    1 ?          Ss        0:1 /usr/lib/systemd/systemd --switched-root --system --deserialize 22 
    2 -          S         0:0 [kthreadd]
    3 -          I<        0:0 [rcu_gp]
    4 -          I<        0:0 [rcu_par_gp]
    6 -          I<        0:0 [kworker/0:0H-kblockd]
    8 -          I<        0:0 [mm_percpu_wq]
    9 -          S         0:0 [ksoftirqd/0]
   10 -          I         0:2 [rcu_sched]
   11 -          S         0:0 [migration/0]
   13 -          S         0:0 [cpuhp/0]
   14 -          S         0:0 [cpuhp/1]
   15 -          S         0:0 [migration/1]
   16 -          S         0:0 [ksoftirqd/1]
   18 -          I<        0:0 [kworker/1:0H-kblockd]
   19 -          S         0:0 [cpuhp/2]
   20 -          S         0:0 [migration/2]
   21 -          S         0:0 [ksoftirqd/2]
   23 -          I<        0:0 [kworker/2:0H-kblockd]
   24 -          S         0:0 [cpuhp/3]
   25 -          S         0:0 [migration/3]
   26 -          S         0:0 [ksoftirqd/3]
   28 -          I<        0:0 [kworker/3:0H-kblockd]
   29 -          S         0:0 [kdevtmpfs]
   30 -          I<        0:0 [netns]
   31 -          S         0:0 [kauditd]
   32 -          S         0:0 [khungtaskd]
   33 -          S         0:0 [oom_reaper]
   34 -          I<        0:0 [writeback]
   35 -          S         0:0 [kcompactd0]
   36 -          SN        0:0 [ksmd]
   37 -          SN        0:0 [khugepaged]
  129 -          I<        0:0 [kintegrityd]
  130 -          I<        0:0 [kblockd]
  131 -          I<        0:0 [blkcg_punt_bio]
  132 -          I<        0:0 [tpm_dev_wq]
  133 -          I<        0:0 [md]
  134 -          I<        0:0 [edac-poller]
  135 -          I<        0:0 [devfreq_wq]
  136 -          S         0:0 [watchdogd]
  138 -          S         0:0 [kswapd0]
  141 -          I<        0:0 [kthrotld]
  142 -          I<        0:0 [acpi_thermal_pm]
  143 -          I<        0:0 [kmpath_rdacd]
  144 -          I<        0:0 [kaluad]
  146 -          I<        0:0 [kstrp]
  147 -          I<        0:0 [zswap-shrink]
  158 -          I<        0:0 [charger_manager]
  159 -          I<        0:0 [kworker/u9:0]
  380 -          I<        0:0 [ata_sff]
  381 -          S         0:0 [scsi_eh_0]
  384 -          I<        0:0 [scsi_tmf_0]
  385 -          S         0:0 [scsi_eh_1]
  386 -          I<        0:0 [scsi_tmf_1]
  399 -          I<        0:0 [kworker/0:1H-kblockd]
  401 -          I<        0:0 [kworker/1:1H-kblockd]
  463 -          I<        0:0 [kdmflush]
  472 -          I<        0:0 [kworker/3:1H-kblockd]
  475 -          I<        0:0 [kdmflush]
  478 -          I<        0:0 [kworker/2:1H-kblockd]
  488 -          I<        0:0 [xfsalloc]
  489 -          I<        0:0 [xfs_mru_cache]
  490 -          I<        0:0 [xfs-buf/dm-0]
  491 -          I<        0:0 [xfs-conv/dm-0]
  492 -          I<        0:0 [xfs-cil/dm-0]
  493 -          I<        0:0 [xfs-reclaim/dm-]
  494 -          I<        0:0 [xfs-eofblocks/d]
  495 -          I<        0:0 [xfs-log/dm-0]
  496 -          S         0:1 [xfsaild/dm-0]
  577 ?          Ss        0:0 /usr/lib/systemd/systemd-journald 
  602 ?          Ss        0:0 /usr/sbin/lvmetad -f 
  606 ?          Ss        0:0 /usr/lib/systemd/systemd-udevd 
  642 -          I<        0:0 [cryptd]
  643 -          I<        0:0 [iprt-VBoxWQueue]
  692 -          I<        0:0 [ttm_swap]
  735 -          I<        0:0 [xfs-buf/sda1]
  737 -          I<        0:0 [xfs-conv/sda1]
  738 -          I<        0:0 [xfs-cil/sda1]
  739 -          I<        0:0 [xfs-reclaim/sda]
  740 -          I<        0:0 [xfs-eofblocks/s]
  743 -          I<        0:0 [xfs-log/sda1]
  744 -          S         0:0 [xfsaild/sda1]
  761 ?          S<sl      0:0 /sbin/auditd 
  786 ?          Ssl       0:0 /usr/lib/polkit-1/polkitd --no-debug 
  787 ?          Ss        0:0 /usr/lib/systemd/systemd-logind 
  794 ?          Ss        0:7 /usr/sbin/irqbalance --foreground 
  795 ?          Ss        0:7 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation 
  800 ?          S         0:0 /usr/sbin/chronyd 
  809 ?          Ssl       0:2 /usr/sbin/NetworkManager --no-daemon 
  812 ?          Ss        0:0 /usr/sbin/crond -n 
  819 /dev/tty1  Ss+       0:0 /sbin/agetty --noclear tty1 linux 
  870 ?          S         0:0 /sbin/dhclient -d -q -sf /usr/libexec/nm-dhcp-helper -pf /var/run/dhclient-eth0.pid -lf /var/lib/NetworkManager/dhclient-8d87eabe-8db7-3364-a0b7-4116bc76ced6-eth0.lease -cf /var/lib/NetworkManager/dhclient-eth0.conf eth0 
 1050 ?          Ss        0:0 /usr/sbin/sshd -D 
 1052 ?          Ssl      0:14 /usr/bin/python2 -Es /usr/sbin/tuned -l -P 
 1053 ?          Ssl       0:7 /usr/sbin/rsyslogd -n 
 1166 ?          Ss        0:0 /usr/libexec/postfix/master -w 
 1170 ?          S         0:0 qmgr -l -t unix -u 
 1435 ?          Sl       0:21 /usr/sbin/VBoxService --pidfile /var/run/vboxadd-service.sh 
 2436 ?          S         0:0 pickup -l -t unix -u 
 2616 -          I         0:0 [kworker/u8:2-events_unbound]
 9574 ?          Ss        0:0 sshd: vagrant [priv] 
 9577 ?          S         0:0 sshd: vagrant@pts/1  
 9578 /dev/pts/1 Ss+       0:0 -bash 
 9837 -          I         0:0 [kworker/2:1-kdmflush]
19484 -          I         0:0 [kworker/3:3-cgroup_pidlist_destroy]
19486 -          I         0:0 [kworker/0:0]
19518 -          I         0:0 [kworker/1:3-cgroup_pidlist_destroy]
19519 -          I         0:0 [kworker/2:0-events]
19520 /dev/pts/1 S+        0:0 sudo ./psax.sh 
19521 /dev/pts/1 S+        0:0 bash ./psax.sh 
29669 -          I         0:0 [kworker/0:2-mm_percpu_wq]
29727 -          I         0:0 [kworker/3:0-mm_percpu_wq]
29788 -          I         0:4 [kworker/1:2-events]
32441 -          I         0:0 [kworker/u8:1-events_unbound]
```
