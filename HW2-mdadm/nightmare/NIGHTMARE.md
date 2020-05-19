# Additional task with two asterisks

перенесети работающую систему с одним диском на RAID 1. Даунтайм на загрузку с нового диска предполагается. В качестве проверики принимается вывод команды lsblk до и после и описание хода решения (можно воспользовать утилитой Script).

Migrate working system frome single disk to raid1. Downtime to boot from new disk is allowed. As result can be `lsblk` output. It is also possible to use `script` utility for console logging.

## Vagrantfile

Vagrantfile is present [here](./Vagrantfile)

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
