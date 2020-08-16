## Task 1: nginx

1. Run nginx on alternative port using 3 different ways:
   - `setsebool` switch;
   - add an alternative port to existing `type`;
   - develop and install `selinux module`;
Expected result: description of every implementation in README (demos and screenshots are welcome).

### nginx selinux experiments

Get process's selinux info
```shell
ps auxZ | grep nginx
```
```log
system_u:system_r:httpd_t:s0    root     22573  0.0  0.7  41416  3508 ?        Ss   21:42   0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
system_u:system_r:httpd_t:s0    nginx    22774  0.0  1.0  74464  5184 ?        S    21:42   0:00 nginx: worker process
```
nginx selinux domain is `httpd_t`. It's a **source** domain.

NOTE: some useful options of `sesearch` utility
```shell
EXPRESSIONS:
  -s NAME, --source=NAME    rules with type/attribute NAME as source
  -t NAME, --target=NAME    rules with type/attribute NAME as target
  -p P1[,P2,...], --perm=P1[,P2...]
                            rules with the specified permission
  -b NAME, --bool=NAME      conditional rules with NAME in the expression
RULE_TYPES:
  -A, --allow               allow rules
OPTIONS:
  -d, --direct
```

Check allowed nginx **target** types:
```shell
sesearch -s httpd_t -Ad
```
Output is supressed because it's very big.


Check which type uses tcp port `8080` (why is nginx already working on port 8080 without any selinux configuration changes)
```shell
semanage port --list | grep 8080
```
```log
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
```

Ensure nginx allow bind and connect to ports `http_cache_port_t`
```shell
sesearch -s httpd_t -t http_cache_port_t -Ad
```
```log
Found 2 semantic av rules:
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_connect ;
```

Which target types nginx has **name_bind** permission
```shell
sesearch -s httpd_t -p name_bind -Ad
```
```log
Found 12 semantic av rules:
   allow httpd_t puppet_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_management_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_messaging_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t ntop_port_t : tcp_socket name_bind ; 
   allow httpd_t http_port_t : udp_socket name_bind ; 
   allow httpd_t http_port_t : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : udp_socket name_bind ; 
   allow httpd_t ftp_port_t : tcp_socket name_bind ; 
   allow httpd_t commplex_main_port_t : tcp_socket name_bind ; 
   allow httpd_t preupgrade_port_t : tcp_socket name_bind ;
```

Which target types nginx has **name_connect** permission
```shell
sesearch -s httpd_t -p name_connect -Ad
```
```log
Found 28 semantic av rules:
   allow httpd_t gopher_port_t : tcp_socket name_connect ; 
   allow httpd_t zabbix_port_t : tcp_socket name_connect ; 
   allow httpd_t squid_port_t : tcp_socket name_connect ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_connect ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_connect ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_connect ; 
   allow httpd_t smtp_port_t : tcp_socket name_connect ; 
   allow httpd_t osapi_compute_port_t : tcp_socket name_connect ; 
   allow httpd_t mongod_port_t : tcp_socket name_connect ; 
   allow httpd_t pop_port_t : tcp_socket name_connect ; 
   allow httpd_t ftp_port_t : tcp_socket name_connect ; 
   allow httpd_t ftp_port_t : tcp_socket name_connect ; 
   allow httpd_t http_cache_port_t : tcp_socket name_connect ; 
   allow httpd_t port_type : tcp_socket name_connect ; 
   allow httpd_t ocsp_port_t : tcp_socket name_connect ; 
   allow httpd_t kerberos_port_t : tcp_socket name_connect ; 
   allow httpd_t mysqld_port_t : tcp_socket name_connect ; 
   allow httpd_t mssql_port_t : tcp_socket name_connect ; 
   allow httpd_t postgresql_port_t : tcp_socket name_connect ; 
   allow httpd_t mythtv_port_t : tcp_socket name_connect ; 
   allow httpd_t oracle_port_t : tcp_socket name_connect ; 
   allow httpd_t cobbler_port_t : tcp_socket name_connect ; 
   allow httpd_t memcache_port_t : tcp_socket name_connect ; 
   allow httpd_t memcache_port_t : tcp_socket name_connect ; 
   allow httpd_t gds_db_port_t : tcp_socket name_connect ; 
   allow httpd_t ldap_port_t : tcp_socket name_connect ; 
   allow httpd_t http_port_t : tcp_socket name_connect ; 
   allow httpd_t http_port_t : tcp_socket name_connect ;
```

The difference between `name_bind` and `name_connect` permissions is:
> When an application is connecting to a port, the name_connect permission is checked. However, when an application binds to the port, the name_bind permission is checked.

Get all ports nginx is allowed to name_bind to
```shell
sesearch -s httpd_t -p name_bind -Ad | awk '$2=/httpd_t/ {print $3}' | xargs -I{} sh -c "semanage port --list | grep {}"
```
```log
puppet_port_t                  tcp      8140
jboss_management_port_t        tcp      4447, 4712, 7600, 9123, 9990, 9999, 18001
jboss_management_port_t        udp      4712, 9123
jboss_messaging_port_t         tcp      5445, 5455
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
ntop_port_t                    tcp      3000-3001
ntop_port_t                    udp      3000-3001
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
ftp_port_t                     tcp      21, 989, 990
ftp_port_t                     udp      989, 990
tftp_port_t                    udp      69
commplex_main_port_t           tcp      5000
commplex_main_port_t           udp      5000
preupgrade_port_t              tcp      8099
```

If we want to have correct experiments then we need to listen tcp port not from list above. For example port `8081` which is:
```shell
semanage port --list | grep 8081
```
```log
transproxy_port_t              tcp      8081
```
So next we set nginx to listen to tcp port `8081`

### Analyse

- `sealert` - analyze and print readable selinux alerts

```shell
sealert -a /var/log/audit/audit.log
```
```log
100% done
found 1 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/nginx from name_bind access on the tcp_socket port 8081.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that nginx should be allowed name_bind access on the port 8081 tcp_socket by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'nginx' --raw | audit2allow -M my-nginx
# semodule -i my-nginx.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                system_u:object_r:transproxy_port_t:s0
Target Objects                port 8081 [ tcp_socket ]
Source                        nginx
Source Path                   /usr/sbin/nginx
Port                          8081
Host                          <Unknown>
Source RPM Packages           nginx-1.19.1-1.el7.ngx.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-266.el7_8.1.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     centos-7
Platform                      Linux centos-7 3.10.0-1127.el7.x86_64 #1 SMP Tue
                              Mar 31 23:36:51 UTC 2020 x86_64 x86_64
Alert Count                   1
First Seen                    2020-08-14 15:35:33 UTC
Last Seen                     2020-08-14 15:35:33 UTC
Local ID                      bfc6efca-3350-4034-9f85-b029fd7d224e

Raw Audit Messages
type=AVC msg=audit(1597419333.68:1080): avc:  denied  { name_bind } for  pid=22521 comm="nginx" src=8081 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:transproxy_port_t:s0 tclass=tcp_socket permissive=0


type=SYSCALL msg=audit(1597419333.68:1080): arch=x86_64 syscall=bind success=no exit=EACCES a0=7 a1=555f5f016da0 a2=10 a3=7fffe948eb30 items=0 ppid=1 pid=22521 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm=nginx exe=/usr/sbin/nginx subj=system_u:system_r:httpd_t:s0 key=(null)

Hash: nginx,httpd_t,transproxy_port_t,tcp_socket,name_bind
```

- `audit2why` - translates SELinux audit messages into a description of why the access was denied (audit2allow -w)

Now we're getting an error `Permission denied` when we're trying to start nginx on port `8081`.

First temporarily disable selinux for nginx
```shell
semanage permissive -a httpd_t
```

Then start nginx and ensure nginx is running
```shell
systemctl restart nginx
systemctl status nginx
```
```log
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2020-08-11 20:50:38 UTC; 4s ago
...
```

Analyse audit.log with `audit2why`
```shell
audit2why < /var/log/audit/audit.log
```
```log
type=AVC msg=audit(1597263536.671:1016): avc:  denied  { name_bind } for  pid=5773 comm="nginx" src=8081 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:transproxy_port_t:s0 tclass=tcp_socket permissive=0

        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.
```

### Workaround

Temporarily disable selinux for nginx
```shell
semanage permissive -a httpd_t
```

Return as it was: disable temporary permission
```shell
semanage permissive -d httpd_t
```

### SELinux policy module

Get reason
```shell
grep 1597263536.671:1016 /var/log/audit/audit.log | audit2why
```
```log
type=AVC msg=audit(1597263536.671:1016): avc:  denied  { name_bind } for  pid=5773 comm="nginx" src=8081 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:transproxy_port_t:s0 tclass=tcp_socket permissive=0

        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.
```

Some useful options for `audit2allow`
```shell
  -M MODULE_PACKAGE, --module-package=MODULE_PACKAGE
                        generate a module package - conflicts with -o and -m
```

Generate a module package
```shell
grep 1597263536.671:1016 /var/log/audit/audit.log | audit2allow -M httpd_add --debug
```
```log
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i httpd_add.pp
```

Load module
```shell
semodule -i httpd_add.pp
```

Disable permissive mode for `httpd_t`
```shell
semanage permissive -d httpd_t
```
```log
libsemanage.semanage_direct_remove_key: Removing last permissive_httpd_t module (no other permissive_httpd_t module exists at another priority).
```

Now nginx starts w/o errors.
```shell
systemctl start nginx
systemctl status nginx
```
```log
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-08-12 20:20:51 UTC; 3s ago
```

After reboot result is the same!

Other way is to use recommendation from `sealert`:
```shell
ausearch -c 'nginx' --raw | audit2allow -M my-nginx
cat my-nginx.te
```
See what the policy will do?
```conf
module my-nginx 1.0;

require {
        type httpd_t;
        type transproxy_port_t;
        class tcp_socket name_bind;
}

#============= httpd_t ==============
allow httpd_t transproxy_port_t:tcp_socket name_bind;
```

It's ok!
```shell
semodule -i my-nginx.pp
```

This way is not recommended or must be used with careful. Always see what's doing a generated policy because your service may be realy compromised!


### Update existing type

It's also possible to add port `8081` to existing type

Get list of existing allowed types for `httpd_t`
```shell
sesearch -s httpd_t -p name_bind -Ad
```
```log
Found 12 semantic av rules:
   allow httpd_t puppet_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_management_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_messaging_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t ntop_port_t : tcp_socket name_bind ; 
   allow httpd_t http_port_t : udp_socket name_bind ; 
   allow httpd_t http_port_t : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : udp_socket name_bind ; 
   allow httpd_t ftp_port_t : tcp_socket name_bind ; 
   allow httpd_t commplex_main_port_t : tcp_socket name_bind ; 
   allow httpd_t preupgrade_port_t : tcp_socket name_bind ;
```

We'll be using `http_port_t` type.

Get allowed ports for `http_port_t`
```shell
semanage port --list | grep http_port_t
```
```log
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
```

NOTE: Some useful options for `semanage`
```shell
  -a, --add             Add a record of the port object type
  -t TYPE, --type TYPE  SELinux Type for the object
  -p PROTO, --proto PROTO
                        Protocol for the specified port (tcp|udp) or internet
                        protocol version for the specified node (ipv4|ipv6).
```

Add port 8081 to type `http_port_t`
```shell
semanage port --add --type http_port_t --proto tcp 8081 
```
```log
ValueError: Port tcp/8081 already defined
```
OOPS!

---

Let's use port `8085` which has context
```shell
seinfo --portcon=8085
```
```log
        portcon tcp 1024-32767 system_u:object_r:unreserved_port_t:s0
        portcon udp 1024-32767 system_u:object_r:unreserved_port_t:s0
        portcon sctp 1024-65535 system_u:object_r:unreserved_port_t:s0
```

Change port to `8085`:
- create new molecule scenario [vagrant-8085](./roles/ansible-role-nginx/molecule/vagrant-8085/)


### Analyze

```shell
LANG=C sealert -a /var/log/audit/audit.log
```
<details><summary>output</summary>
<p>

```log
100% done
found 1 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/nginx from name_bind access on the tcp_socket port 8085.

*****  Plugin bind_ports (92.2 confidence) suggests   ************************

If you want to allow /usr/sbin/nginx to bind to network port 8085
Then you need to modify the port type.
Do
# semanage port -a -t PORT_TYPE -p tcp 8085
    where PORT_TYPE is one of the following: http_cache_port_t, http_port_t, jboss_management_port_t, jboss_messaging_port_t, ntop_port_t, puppet_port_t.

*****  Plugin catchall_boolean (7.83 confidence) suggests   ******************

If you want to allow nis to enabled
Then you must tell SELinux about this by enabling the 'nis_enabled' boolean.

Do
setsebool -P nis_enabled 1

*****  Plugin catchall (1.41 confidence) suggests   **************************

If you believe that nginx should be allowed name_bind access on the port 8085 tcp_socket by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'nginx' --raw | audit2allow -M my-nginx
# semodule -i my-nginx.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                system_u:object_r:unreserved_port_t:s0
Target Objects                port 8085 [ tcp_socket ]
Source                        nginx
Source Path                   /usr/sbin/nginx
Port                          8085
Host                          <Unknown>
Source RPM Packages           nginx-1.19.1-1.el7.ngx.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-266.el7_8.1.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     centos-7
Platform                      Linux centos-7 3.10.0-957.12.2.el7.x86_64 #1 SMP
                              Tue May 14 21:24:32 UTC 2019 x86_64 x86_64
Alert Count                   1
First Seen                    2020-08-16 17:29:59 UTC
Last Seen                     2020-08-16 17:29:59 UTC
Local ID                      555705d6-de08-4e0a-85f8-c29e53a87ba1

Raw Audit Messages
type=AVC msg=audit(1597598999.789:1052): avc:  denied  { name_bind } for  pid=5908 comm="nginx" src=8085 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0


type=SYSCALL msg=audit(1597598999.789:1052): arch=x86_64 syscall=bind success=no exit=EACCES a0=7 a1=5632e8e42da0 a2=10 a3=7ffd76eb2cd0 items=0 ppid=1 pid=5908 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm=nginx exe=/usr/sbin/nginx subj=system_u:system_r:httpd_t:s0 key=(null)

Hash: nginx,httpd_t,unreserved_port_t,tcp_socket,name_bind
```
</p>
</details>

There is three variants to resolve a problem:

- If you want to allow /usr/sbin/nginx to bind to network port 8085 then you need to modify the port type (it's possible because port `8085` belongs to selinux type `unreserved_port_t`)
- If you want to allow nis to enabled then you must tell SELinux about this by enabling the `nis_enabled` boolean.
- If you believe that nginx should be allowed name_bind access on the port 8085 tcp_socket by default then you should report this as a bug. (Intresting but also useful variant ^_^)
- You can generate a local policy module to allow this access. (This will create SELinux policy which allows nginx to bind to **all `unreserved_port_t` ports**. Is it realy what we want to?)


### Update existing type. Part 2

The `ausearch` adviced:

If you want to allow /usr/sbin/nginx to bind to network port 8085 then you need to modify the port type.

Do
```shell
# semanage port -a -t PORT_TYPE -p tcp 8085
    where PORT_TYPE is one of the following: http_cache_port_t, http_port_t, jboss_management_port_t, jboss_messaging_port_t, ntop_port_t, puppet_port_t.
```

And we will do:
```shell
semanage port -a -t http_port_t -p tcp 8085
```
Then check
```shell
systemctl start nginx
systemctl status nginx
```
``log
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2020-08-16 20:41:41 UTC; 4s ago
...
```
And get site content
```shell
curl 127.0.0.1:8085
```
That's it!
```log
centos-7  ^_^
```

Mmm, there is nice ansible module ^_^ [seport](https://docs.ansible.com/ansible/latest/modules/seport_module.html)

Ansible, your time has come!

- Add [ansible-role-nginx/tasks/selinux/selinux_seport.yaml](HW13-selinux/roles/ansible-role-nginx/tasks/selinux/selinux_seport.yaml)
- Add variable `nginx_selinux_seport` to enable/disable this action
- Add variable `nginx_selinux_seport_type: http_port_t` to set type to add port to.

### sebool

- `sebool` flag https://wiki.centos.org/TipsAndTricks/SelinuxBooleans

If you want to allow nis to enabled
Then you must tell SELinux about this by enabling the `nis_enabled` boolean.

What does `nis_enabled` do?
```shell
semanage boolean --list | grep nis_enabled
```
```log
nis_enabled                    (вкл. , вкл.)  Allow nis to enabled
```

Do
```shell
setsebool -P nis_enabled 1
```

Then `nginx` starts without errors.
```shell
systemctl start nginx
```

I think this isn't the best way because a boolean `nis_enabled` gives too many permissions.
```shell
semanage boolean -l | grep nis_enabled | head
```
```log
sesearch -Ad -b nis_enabled | head
Found 3797 semantic av rules:
   allow sshd_t sshd_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow sshd_t sshd_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow denyhosts_t denyhosts_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow newrole_t port_t : udp_socket name_bind ; 
   allow xdm_t server_packet_t : packet recv ; 
   allow xdm_t server_packet_t : packet send ; 
   allow pwauth_t pwauth_t : tcp_socket { ioctl read write create getattr setattr lock append bind connect listen accept getopt setopt shutdown } ; 
   allow secadm_su_t port_t : tcp_socket name_connect ; 
   allow secadm_su_t port_t : tcp_socket name_bind ;
...
```
but when we're configuring some standard server role it may be useful.
