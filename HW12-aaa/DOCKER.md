# Task 2*: docker

Allow a specific user to work with docker and to restart docker service

## Information

- ACL https://www.redhat.com/sysadmin/linux-access-control-lists
- ansible `acl` module https://docs.ansible.com/ansible/latest/modules/acl_module.html
- PolicyKit https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/desktop_migration_and_administration_guide/policykit

## Implementation

Created [ansible-role-dockermgr](./roles/ansible-role-dockermgr/) which:
1. Install docker (if variable `dockermgr_install` is true).
2. Allow r/w access for users listed in the list `dockermgr_managers:` to `/var/run/docker.sock` after docker service starts using ACL.
3. Allow systemd services management (start/stop/restart etc...) for users listed in the list `dockermgr_managers:`. Add PolKit rule which allows `org.freedesktop.systemd1.manage-units` to these users.

## How to run

`ansible>=2.9` must be installed. If it isn't, do these steps:

tested on Ubuntu 18.04
```shell
# Install make
sudo apt install make
# Create venv
make venv
# Activate venv
source .venv/bin/activate
```

Up vagrant instance
```shell
vagrant up
```
Instance would be provisioned automatically

There are _some tests_ in `post_task:` section in [provision.yml](./provision.yml)

## How to check

Login to vagrant instance
```shell
vagrant ssh
```

Ensure user `vagrant` can execute `docker` commands
```shell
[vagrant@hw12-aaa ~]$ docker info
```
<details><summary>output</summary>
<p>

```log
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.13.1
Storage Driver: overlay2
 Backing Filesystem: xfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: journald
Cgroup Driver: systemd
Plugins: 
 Volume: local
 Network: bridge host macvlan null overlay
Swarm: inactive
Runtimes: docker-runc runc
Default Runtime: docker-runc
Init Binary: /usr/libexec/docker/docker-init-current
containerd version:  (expected: aa8187dbd3b7ad67d8e5e3a15115d3eef43a7ed1)
runc version: 66aedde759f33c190954815fb765eedc1d782dd9 (expected: 9df8b306d01f59d3a8029be411de015b7304dd8f)
init version: fec3683b971d9c3ef73f284f176672c44b448662 (expected: 949e6facb77383876aeff8a6944dde66b3089574)
Security Options:
 seccomp
  WARNING: You're not using the default seccomp profile
  Profile: /etc/docker/seccomp.json
Kernel Version: 5.6.11-1.el7.elrepo.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
Number of Docker Hooks: 3
CPUs: 2
Total Memory: 479.8 MiB
Name: hw12-aaa
ID: VVJQ:MMBY:M2DO:5ZC6:2SSM:UF6O:B6TD:EG64:UYBI:AQ5G:CFHF:63AL
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
Registries: docker.io (secure)
```
</p>
</details>

Ensure user `vagrant` can restart `docker` service
```shell
[vagrant@hw12-aaa ~]$ systemctl restart docker.service
[vagrant@hw12-aaa ~]$
```
