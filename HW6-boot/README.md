# OS boot

- [OS boot](#os-boot)
  - [LogIn without password](#login-without-password)
    - [init](#init)
    - [rd.break](#rdbreak)
    - [rw init sysroot](#rw-init-sysroot)
  - [Rename root VG](#rename-root-vg)
    - [Run via script](#run-via-script)

## LogIn without password

First open VirtualBox.
Then run vagrant VM
```shell
vagrant up
```
and stop boot brocess on grub boot menu.

### init

1. Select grub menu item by arrows up/down and press `e` to edit it.
2. Add `init=/bin/sh` at end of line started with `linux16`
   ![](./assets/grub-init-sh.png)
3. Press `ctrl+x` to boot with updated menu item... And we're in!
   ![](./assets/brub-init-root.png)
4. Remount rootfs with write access
   ```shell
   mount -o remount,rw /
   ```
5. Profit!

![](./assets/grub-init-rw.png)

### rd.break

1. Select grub menu item by arrows up/down and press `e` to edit it.
2. Add `rd.break` at end of line started with `linux16`
   ![](./assets/brub-rd-break-menuitem.png)
3. Press `ctrl+x` to boot with updated menu item... And we're in!
   ![](./assets/grub-rd-break-login.png)
4. Now root filesystem is available at `/sysroot`. Remount it readwrite
   ```shell
   mount -o remount,rw /sysroot
   ```
5. Chroot to `/sysroot` and change `root` password
   ```shell
   chroot /sysroot
   passwd root
   touch /.autorelabel
   ```
   ![](./assets/grub-rd-break-password.png)
6. Then exit chroot, reboot and try to login as root with new password
   ![](./assets/grub-rd-break-login-as-root.png)

### rw init sysroot

1. Select grub menu item by arrows up/down and press `e` to edit it.
2. Replace `ro` to `rw` and append `init=/sysroot/bin/sh` at end of line started with `linux16`
   ![](./assets/grub-init-syslinux-menuitem.png)
3. Press `ctrl+x` to boot with updated menu item... And we're in!
   ![](./assets/grub-init-sysroot-login.png)
4. And we already have write access to sysroot
   ![](./assets/grub-init-sysroot-rw.png)


## Rename root VG

First, recreate VM (VM was renamed to `hw6`)
```shell
vagrant destroy
vagrant up
vagrant ssh
```

Check current config
```shell
sudo vgs
```
```log
  VG     #PV #LV #SN Attr   VSize  VFree
  centos   1   2   0 wz--n- <9,00g    0
```
The name of VG is `centos`.

Let's rename it to `OtusRoot`
```shell
sudo vgrename centos OtusRoot
```
```log
  Volume group "centos" successfully renamed to "OtusRoot"
```

Fix `/etc/fstab`
```shell
sudo sed -i.old 's#^/dev/mapper/centos-#/dev/mapper/OtusRoot-#g' /etc/fstab
cat /etc/fstab
```
```fstab
...
/dev/mapper/OtusRoot-root /                       xfs     defaults        0 0
UUID=1575a298-f38b-4155-8e0e-9e2a0763f286 /boot                   xfs     defaults        0 0
/dev/mapper/OtusRoot-swap swap                    swap    defaults        0 0
```

Fix `/etc/default/grub`
```shell
sudo sed -i.old 's#lvm.lv=centos/#lvm.lv=OtusRoot/#g' /etc/default/grub
cat /etc/default/grub
```
```shell
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="ipv6.disable=1 net.ifnames=0 biosdevname=0 crashkernel=auto spectre_v2=retpoline rd.lvm.lv=OtusRoot/root rd.lvm.lv=OtusRoot/swap rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
```

Fix `/boot/grub2/grub.cfg`
```shell
sudo sed -i.old1 's#/dev/mapper/centos-#/dev/mapper/OtusRoot-#g' /boot/grub2/grub.cfg
sudo sed -i.old2 's#lvm.lv=centos/#lvm.lv=OtusRoot/#g' /boot/grub2/grub.cfg
sudo cat /boot/grub2/grub.cfg
```
[output](./assets/vg-renamed-grub.cfg)

Regenerate `initrd` with new VG name
```shell
sudo mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```
[output](./assets/mkinitrd.log)

And finally reboot
```shell
sudo reboot
```

Check result
```shell
sudo vgs
```
```log
  VG       #PV #LV #SN Attr   VSize  VFree
  OtusRoot   1   2   0 wz--n- <9,00g    0
```

### Run via script

Script [rename-vg.sh](./scripts/rename-vg.sh) must be applied to newly created VM.

Run on host
```shell
vagrant ssh < scripts/rename-vg.sh 2>&1 | tee ./assets/rename-vg.log
vagrant reload
```
[output](./assets/rename-vg.log)

Ensure VG was renamed (run on host)
```shell
vagrant ssh -c "sudo vgs"
```
```log
  VG       #PV #LV #SN Attr   VSize  VFree
  OtusRoot   1   2   0 wz--n- <9,00g    0 
Connection to 127.0.0.1 closed.
```

Done!

> Note: VM hangs after `reboot` or `shutdown -r now` at end of script. It's solved by run `vagrant reload` after script completed to work.
