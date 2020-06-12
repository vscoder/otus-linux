# Unit file for spawn-fcgi

- [Unit file for spawn-fcgi](#unit-file-for-spawn-fcgi)
  - [Useful materials](#useful-materials)
  - [Installation](#installation)
  - [systemd unit file](#systemd-unit-file)
  - [Environment file](#environment-file)
  - [Run service](#run-service)
  - [Provisioning](#provisioning)

## Useful materials

SystemD FastCGI multiple processes without spawn-fastcgi https://nileshgr.com/2016/07/09/systemd-fastcgi-multiple-processes

## Installation

Install `spawn-fcgi` and `php-cli` to run with spawn-fcgi service
```shell
sudo yum install -y spawn-fcgi php-cli
```

Get content of 
```shell
cat /etc/init.d/spawn-fcgi
```
<details><summary>output</summary>
<p>

```shell
#!/bin/sh
#
# spawn-fcgi   Start and stop FastCGI processes
#
# chkconfig:   - 80 20
# description: Spawn FastCGI scripts to be used by web servers

### BEGIN INIT INFO
# Provides: 
# Required-Start: $local_fs $network $syslog $remote_fs $named
# Required-Stop: 
# Should-Start: 
# Should-Stop: 
# Default-Start: 
# Default-Stop: 0 1 2 3 4 5 6
# Short-Description: Start and stop FastCGI processes
# Description:       Spawn FastCGI scripts to be used by web servers
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

exec="/usr/bin/spawn-fcgi"
prog="spawn-fcgi"
config="/etc/sysconfig/spawn-fcgi"

[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

lockfile=/var/lock/subsys/$prog

start() {
    [ -x $exec ] || exit 5
    [ -f $config ] || exit 6
    echo -n $"Starting $prog: "
    # Just in case this is left over with wrong ownership
    [ -n "${SOCKET}" -a -S "${SOCKET}" ] && rm -f ${SOCKET}
    daemon "$exec $OPTIONS >/dev/null"
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog
    # Remove the socket in order to never leave it with wrong ownership
    [ -n "${SOCKET}" -a -S "${SOCKET}" ] && rm -f ${SOCKET}
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status $prog
}

rh_status_q() {
    rh_status &>/dev/null
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
```
</p>
</details>

## systemd unit file

Create unit-file `spawn-fcgi.service` at `/etc/systemd/system`

[spawn-fcgi.service](./spawn-fcgi/spawn-fcgi.service)
```conf
# /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=spawn-fcgi service
After=syslog.target

[Service]
# Type of process running
Type=forking
# For type forking it's need to set PID file location
# %p is service name in this case
PIDFile=/var/run/%p.pid
# Set process name for logs
SyslogIdentifier=%p
# Path to file with environment variables
EnvironmentFile=/etc/sysconfig/spawn-fcgi
# Run service. OPTIONS is defined in environment file
ExecStart=/usr/bin/spawn-fcgi $OPTIONS

[Install]
WantedBy=multi-user.target
```

## Environment file

Contents of `/etc/sysconfig/spawn-fcgi`
```shell
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u nobody -g nobody -s $SOCKET -S -M 0600 -C 16 -F 1 -P /var/run/spawn-fcgi.pid -- /usr/bin/php-cgi"
```

## Run service

Run systemd service
```shell
sudo systemctl start spawn-fcgi
sudo systemctl status spawn-fcgi
```
<details><summary>output</summary>
<p>

```log
● spawn-fcgi.service - spawn-fcgi service
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)
   Active: active (running) since Пт 2020-06-12 18:29:22 UTC; 4s ago
  Process: 4195 ExecStart=/usr/bin/spawn-fcgi $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 4196 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
           ├─4196 /usr/bin/php-cgi
           ├─4197 /usr/bin/php-cgi
           ├─4198 /usr/bin/php-cgi
           ├─4199 /usr/bin/php-cgi
           ├─4200 /usr/bin/php-cgi
           ├─4201 /usr/bin/php-cgi
           ├─4202 /usr/bin/php-cgi
           ├─4203 /usr/bin/php-cgi
           ├─4204 /usr/bin/php-cgi
           ├─4205 /usr/bin/php-cgi
           ├─4206 /usr/bin/php-cgi
           ├─4207 /usr/bin/php-cgi
           ├─4208 /usr/bin/php-cgi
           ├─4209 /usr/bin/php-cgi
           ├─4210 /usr/bin/php-cgi
           ├─4211 /usr/bin/php-cgi
           └─4212 /usr/bin/php-cgi

июн 12 18:29:22 hw7-systemd systemd[1]: Starting spawn-fcgi service...
июн 12 18:29:22 hw7-systemd spawn-fcgi[4195]: spawn-fcgi: child spawned successfully: PID: 4196
июн 12 18:29:22 hw7-systemd systemd[1]: Started spawn-fcgi service.
```
</p>
</details>

## Provisioning

There are 2 files and 1 script used for provisioning.

Files:
- `./spawn-fcgi/spawn-fcgi` - environment config file
- `./spawn-fcgi/spawn-fcgi.service` - systemd service file

Script:
- `./scripts/3-spawn-fcgi-service.sh` - install, enable and start systemd service
