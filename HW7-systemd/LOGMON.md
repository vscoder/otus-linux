# Log monitoring service

This service periodically (by default every 30 seconds) look journald logs for line matching pattern (default is `testmsg`). If such line is founded, then write it to log file (default is `/tmp/logmon.log`)

- [Log monitoring service](#log-monitoring-service)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Check](#check)
  - [Provisioning](#provisioning)
  - [Logmon service description](#logmon-service-description)
    - [Configuration](#configuration)
    - [Systemd unit-file](#systemd-unit-file)

## Requirements

`jq` must be installed. It's available on CentOS from from EPEL repository.

Tested only on CentOS 7

## Installation

Create user `logmon` and add it to group `systemd-journal`
```shell
sudo adduser --no-create-home --no-user-group --gid systemd-journal --shell /usr/sbin/nologin logmon
```

Copy `logmon.sh` to `/usr/local/bin` and grant execution permission on it
```shell
sudo cp /vagrant/logmon/logmon.sh /usr/local/bin/logmon.sh
sudo chmod +x /usr/local/bin/logmon.sh
```

Copy `logmon` configuration file to `/etc/sysconfig` (edit if necessary)
```shell
sudo cp /vagrant/logmon/logmon /etc/sysconfig/logmon
```

Copy systemd unit file to `/etc/systemd/system` and reload systemd
```shell
sudo cp /vagrant/logmon/logmon.service /etc/systemd/system/
sudo systemctl daemon-reload
```

Enable and start `logmon.service`
```shell
sudo systemctl enable logmon.service
sudo systemctl start logmon.service
```

## Check

Pass configured pattern to syslog
```shell
logger Test message with logmon pattern 'testmsg' in it
```

Check created log file
```shell
cat /tmp/logmon.log
```

## Provisioning

After `vagrant up` service is automatically installed and configured with Vagrant provisioner, so it isn't need to execute these commands manually

## Logmon service description

[logmon.sh](./logmon/logmon.sh)

### Configuration

Script can be configured with Environment Variables, stored it `/etc/sysconfig/logmon`

```shell
# Filename to log pattern matches to
LOG=${LOG:-/tmp/logmon.log}
# Read log every $SEC seconds
SEC=${SEC:=30}
# grep template pattern
PATTERN=${PATTERN:-testmsg}
```

### Systemd unit-file

Good article https://medium.com/@benmorel/creating-a-linux-service-with-systemd-611b5c8b91d6

[logmon.service](./logmon/logmon.service)

Systemd runs `logmon.sh` service as user `logmon`.
> NOTE: user `logmon` must be a member of group `systemd-journal` to read all logs
