# OS boot

- [OS boot](#os-boot)
  - [Log in without password](#log-in-without-password)

## Log in without password

First open VirtualBox.
Then run vagrant VM
```shell
vagrant up
```
and stop boot brocess on grub boot menu.

1. Select grub menu item by arrows up/down and press `e` to edit it.
2. Add `init=/bin/sh` at end of line started with `linux16`
![](assets/grub-init-sh.png)
3. Press `ctrl+x` to boot with updated menu item... And we're in!
![](./assets/brub-init-root.pngbrub-init-root.png)
4. Remount rootfs with write access
   ```shell
   mount -o remount,rw /
   ```
5. Profit!
![](./assets/grub-init-rw.png)
