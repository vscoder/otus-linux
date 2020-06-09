# Home work 6: boot process

## Main tasks

1. Log in to the system w/o password
2. Rename LVM VolumeGroup with root LV on it
3. Add custom initrd module

[Solution](./BOOT.md)

## Hard task

Сконфигурировать систему без отдельного раздела с /boot, а только с LVM
Репозиторий с пропатченым grub: https://yum.rumyantsev.com/centos/7/x86_64/
PV необходимо инициализировать с параметром --bootloaderareasize 1m

Copnfigure a system w/o separate boot partition. Boot from root LV on LVM.
Patched grub repo: https://yum.rumyantsev.com/centos/7/x86_64/
PV must be initialized with param `--bootloaderareasize 1m`

TODO: solution (sometimes later)
