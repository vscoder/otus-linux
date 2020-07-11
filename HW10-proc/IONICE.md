# ionice.sh

The script [ionice.sh](./ionice.sh) runs 2 background `dd` processes with class `Best-effort` and prio `0` and `7` and start `iotop` in batch mode to show result.

## Classes

- **Idle** - A  program running with idle I/O priority will only get disk time when no other program has asked for disk I/O for a defined grace period.  The impact of an idle I/O process on normal system activity should be zero.  This scheduling class does not take a priority  argument.   Presently, this scheduling class is permitted for an ordinary user (since kernel 2.6.25).

- **Best-effort** - This  is  the  effective scheduling class for any process that has not asked for a specific I/O priority.  This class takes a priority argument from 0-7, with a lower number being higher priority.  Programs running at the same best-effort priority are served in a round-robin fashion.
Note that before kernel 2.6.26 a process that has not asked for an I/O priority formally uses "none" as scheduling class, but the I/O scheduler will  treat  such processes as if it were in the best-effort class.  The priority within the best-effort class will be dynamically derived from the CPU nice level of the process: io_priority = (cpu_nice + 20) / 5.
For kernels after 2.6.26 with the CFQ I/O scheduler, a process that has not asked for an I/O priority inherits its CPU scheduling  class.   The I/O priority is derived from the CPU nice level of the process (same as before kernel 2.6.26).
- **Realtime** - The  RT  scheduling  class is given first access to the disk, regardless of what else is going on in the system.  Thus the RT class needs to be used with some care, as it can starve other processes.  As with the best-effort class, 8 priority levels are defined denoting how  big  a  time slice a given process will receive on each scheduling window.  This scheduling class is not permitted for an ordinary (i.e., non-root) user.

## Notes

`ionice` works only with `cfq` scheduler. But kernel 5.6 hasn't `cfq`. Because of it, we need to reboot with kernel version 3.10.

## Implementation

Reboot with kernel 3.10

```shell
echo "sudo grub2-set-default 0 && sudo reboot" | vagrant ssh
vagrant ssh
```

Set scheduler to `cfq`
```shell
echo cfq | sudo tee /sys/block/sda/queue/scheduler
```

Create function and run tests
```shell
##
# Functions
##
run_ioniced() {
    PRIO=$1
    ionice -c 2 -n $PRIO dd if=/dev/zero of=/tmp/prio-${PRIO}.2Gb bs=1M count=2048 oflag=direct &
}

##
# Run tests
##
{
    run_ioniced 0
    run_ioniced 7
    sudo iotop -obn 5
}
```
Output:
```log
[1] 1585
[2] 1586
Total DISK READ :       0.00 B/s | Total DISK WRITE :     518.69 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     518.69 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1586 be/7 vagrant     0.00 B/s  518.69 M/s  0.00 % 54.18 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     845.85 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     845.85 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1585 be/0 vagrant     0.00 B/s  661.62 M/s  0.00 % 92.92 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
 1586 be/7 vagrant     0.00 B/s  184.22 M/s  0.00 % 83.39 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     538.76 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     538.76 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1586 be/7 vagrant     0.00 B/s  139.57 M/s  0.00 % 99.99 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
 1585 be/0 vagrant     0.00 B/s  399.19 M/s  0.00 % 91.20 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     547.91 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     547.91 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1585 be/0 vagrant     0.00 B/s  411.90 M/s  0.00 % 90.45 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
 1586 be/7 vagrant     0.00 B/s  136.01 M/s  0.00 % 82.16 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     696.45 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     696.70 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1586 be/7 vagrant     0.00 B/s  207.45 M/s  0.00 % 99.99 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
 1585 be/0 vagrant     0.00 B/s  489.00 M/s  0.00 % 89.79 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
[vagrant@hw10-proc ~]$ 2048+0 записей получено
2048+0 записей отправлено
 скопировано 2147483648 байт (2,1 GB), 4,17328 c, 515 MB/c
2048+0 записей получено
2048+0 записей отправлено
 скопировано 2147483648 байт (2,1 GB), 5,39265 c, 398 MB/c

[1]-  Done                    ionice -c 2 -n $PRIO dd if=/dev/zero of=/tmp/prio-${PRIO}.2Gb bs=1M count=2048 oflag=direct
[2]+  Done                    ionice -c 2 -n $PRIO dd if=/dev/zero of=/tmp/prio-${PRIO}.2Gb bs=1M count=2048 oflag=direct
```

As we can see, process with prio 0 (pid 1585) has more write speed than process with prio 7 (pid 1586).
