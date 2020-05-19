# Additional task

Just one asterisk and 30 minutes of time.

## Breefing

Automatically configure raid within Vagrantfile

## Operation details

Configure shell provision in [./Vagrantfile](./Vagrantfile)
```ruby
      box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        yum install -y mdadm smartmontools hdparm gdisk
        # Create raid5 on vagrant up
        sudo mdadm --create --verbose /dev/md0 -l 5 -n 6 /dev/sd{b,c,d,e,f,g}
        # Create mdadm.conf
        sudo mkdir /etc/mdadm
        echo "DEVICE partitions" | sudo tee /etc/mdadm/mdadm.conf
        sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee -a /etc/mdadm/mdadm.conf
        cat /etc/mdadm/mdadm.conf
        # Here can be filesystem and partitions creation commands, or you ads can be placed here ^_^
      SHELL
```
