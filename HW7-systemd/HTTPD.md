# Multiple instances of HTTPD

- [Multiple instances of HTTPD](#multiple-instances-of-httpd)
  - [Prepare](#prepare)
  - [Configure](#configure)
  - [How to run](#how-to-run)
  - [Provisioning](#provisioning)

## Prepare

Install httpd
```shell
sudo yum install -y httpd
```
[output](./logs/install-httpd.log)

Original httpd unit file `/usr/lib/systemd/system/httpd.service`
```conf
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd
ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

<details><summary>Original config `/etc/sysconfig/httpd`</summary>
<p>

```shell
#
# This file can be used to set additional environment variables for
# the httpd process, or pass additional options to the httpd
# executable.
#
# Note: With previous versions of httpd, the MPM could be changed by
# editing an "HTTPD" variable here.  With the current version, that
# variable is now ignored.  The MPM is a loadable module, and the
# choice of MPM can be changed by editing the configuration file
# /etc/httpd/conf.modules.d/00-mpm.conf.
# 

#
# To pass additional options (for instance, -D definitions) to the
# httpd binary at startup, set OPTIONS here.
#
#OPTIONS=

#
# This setting ensures the httpd process is started in the "C" locale
# by default.  (Some modules will not behave correctly if
# case-sensitive string comparisons are performed in a different
# locale.)
#
LANG=C
```
</p>
</details>


## Configure

Create new httpd unit file named `httpd@.service`. Set `Type=forking` and define `PidFile` relative to instance name.

`/etc/systemd/system/httpd@.service`
```conf
[Unit]
Description=The Apache HTTP Server instance %I
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=forking
PIDFile=/var/run/httpd/httpd-%i.pid
EnvironmentFile=/etc/sysconfig/httpd@%i
ExecStart=/usr/sbin/httpd $OPTIONS -c 'PidFile "/var/run/httpd/httpd-%i.pid"'
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
RequiredBy=httpd.target
# If httpd.target doesn't exists, comment above uncomment underlying directives
#WantedBy=multi-user.target
```

It's also possible to create `httpd.target` to manage all instances

`/etc/systemd/system/httpd.target`
```conf
[Unit]
Description=The Apache HTTP Server instances

[Install]
WantedBy=multi-user.target  
```

> The main difference between `RequiredBy` and `WantedBy` directives in `[Install]` is how to display the `target`'s status. When `WantedBy` is defined, the target is **active** if only **one instance** is active. When `RequiredBy` is defined, the target is **active** only when **all instances** are active.


Create two configs with different `serverroot`
```shell
cat << EOF | sudo tee /etc/sysconfig/httpd@8080
LANG=C
OPTIONS=-d /etc/httpd-8080
EOF
cat << EOF | sudo tee /etc/sysconfig/httpd@8081
LANG=C
OPTIONS=-d /etc/httpd-8081
EOF
```

Create `serverroot` directories
```shell
sudo cp -a /etc/httpd /etc/httpd-8080
sudo sed -i 's#^ServerRoot "/etc/httpd"$#ServerRoot "/etc/httpd-8080"#g' /etc/httpd-8080/conf/httpd.conf
sudo sed -i 's#^Listen 80$#Listen 8080#g' /etc/httpd-8080/conf/httpd.conf
sudo cp -a /etc/httpd /etc/httpd-8081
sudo sed -i 's#^ServerRoot "/etc/httpd"$#ServerRoot "/etc/httpd-8081"#g' /etc/httpd-8081/conf/httpd.conf
sudo sed -i 's#^Listen 80$#Listen 8081#g' /etc/httpd-8081/conf/httpd.conf
```

## How to run

**Important note**: It isn't necessarry to make some symlinks from original `httpd@.service`. 

To start service instances it just needs to create a config at `/etc/sysconfig/httpd@<instance>` and start the service with command `sudo systemctl start httpd@<instance>.service`

There is a list of commands to run all services now and with system boot:
```shell
{
    sudo systemctl enable httpd@808{0,1}.service
    sudo systemctl enable httpd.target
    sudo systemctl start httpd.target
}
```

Ensure all services are running
```shell
systemctl status httpd.target httpd@808{0,1}.service
```
```log
● httpd.target - The Apache HTTP Server instances
   Loaded: loaded (/etc/systemd/system/httpd.target; enabled; vendor preset: disabled)
   Active: active since Сб 2020-06-13 13:31:35 UTC; 29min ago

● httpd@8080.service - The Apache HTTP Server instance 8080
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Сб 2020-06-13 13:25:56 UTC; 35min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 12280 (httpd)
   CGroup: /system.slice/system-httpd.slice/httpd@8080.service
           ├─12280 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12281 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12282 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12283 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12284 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           └─12285 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"

● httpd@8081.service - The Apache HTTP Server instance 8081
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Сб 2020-06-13 14:00:57 UTC; 31s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 23836 ExecStart=/usr/sbin/httpd $OPTIONS -c PidFile "/var/run/httpd/httpd-%i.pid" (code=exited, status=0/SUCCESS)
 Main PID: 23837 (httpd)
   CGroup: /system.slice/system-httpd.slice/httpd@8081.service
           ├─23837 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23838 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23839 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23840 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23841 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           └─23842 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
```

## Provisioning

Provision script is here: [4-httpd-service-template.sh](./scripts/4-httpd-service-template.sh)

Other files are at [httpd](./httpd) directory. There are:
- `httpd@.service` - systemd service template
- `httpd.target` - systemd target

`/etc/sysconfig/httpd@*` configs are generated automatically by provisioning script

Finish!
