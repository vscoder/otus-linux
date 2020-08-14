# HomeWork 12: Authentication Authorization Accounting

## Tasks

The main target is ability to diagnose a problems and to fix SELinux policies, when it's necessary to app functioned properly.
1. Run nginx on alternative port using 3 different ways:
   - `setsebool` switch;
   - add an alternative port to existing `type`;
   - develop and install `selinux module`;
Expected result: description of every implementation in README (demos and screenshots are welcome).

2. Ensure that the application works when selinux is enabled
   - deploy attached [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems);
   - find out why the DNS zone refresh functionality isn't working;
   - suggest a solution to the problem;
   - choose one of the solutions, justify the choice of a solution;
   - implement the solution and make a demo
Expected result:
- README with a description of the broken functionality analyse, an available solutions and a justifycation of choosed solution;
- A fixed `test environment` or a demo of the proper DNS zone refresh functionality whth a screenshots and a description.


Цель: Тренируем умение работать с SELinux: диагностировать проблемы и модифицировать политики SELinux для корректной работы приложений, если это требуется.
1. Запустить nginx на нестандартном порту 3-мя разными способами:
- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.
К сдаче:
- README с описанием каждого решения (скриншоты и демонстрация приветствуются).

2. Обеспечить работоспособность приложения при включенном selinux.
- Развернуть приложенный стенд
https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems
- Выяснить причину неработоспособности механизма обновления зоны (см. README);
- Предложить решение (или решения) для данной проблемы;
- Выбрать одно из решений для реализации, предварительно обосновав выбор;
- Реализовать выбранное решение и продемонстрировать его работоспособность.
К сдаче:
- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них;
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.
Критерии оценки:
Обязательно для выполнения:
- 1 балл: для задания 1 описаны, реализованы и продемонстрированы все 3 способа решения;
- 1 балл: для задания 2 описана причина неработоспособности механизма обновления зоны;
- 1 балл: для задания 2 реализован и продемонстрирован один из способов решения;
Опционально для выполнения:
- 1 балл: для задания 2 предложено более одного способа решения;
- 1 балл: для задания 2 обоснованно(!) выбран один из способов решения.

## Documentation

### links

- MUST READ! https://defcon.ru/os-security/1264/
- MUST READ! https://www.nginx.com/blog/using-nginx-plus-with-selinux/
- Nice article about SELinux and Networking: https://wiki.gentoo.org/wiki/SELinux/Networking
- RedHat 7 guide https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-troubleshooting-fixing_problems

### utils

Package `setools-console`:
- `sesearch`
- `seinfo`
- `findcon`
- `getsebool`
- `setsebool`
Package `policycoreutils-python`:
- `audit2allow`
- `audit2why`
Package `policycoreutils-newrole`:
- `newrole`
Package `selinux-policy-mls`:
- `selinux-policy-mls`
Package `setroubleshoot-server`:
- `sealert`

### contexts

Selinux contexts are at `/etc/selinux/targeted/contexts/files`

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

Disable temporary permission
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

In's ok!
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

So, let's change port to `8085` (here we change molecule defa)


### sebool

- `sebool` flag https://wiki.centos.org/TipsAndTricks/SelinuxBooleans

Google says to use selinux boolean flag `httpd_can_network_connect` and `httpd_can_network_relay`.

Get flag `httpd_can_network_connect` info
```shell
semanage boolean --list | grep httpd_can_network_connect\ 
```
```log
httpd_can_network_connect      (выкл.,выкл.)  Allow httpd to can network connect
```

Get flag `httpd_can_network_relay` info
```shell
semanage boolean --list | grep httpd_can_network_relay\ 
```
```log
httpd_can_network_relay        (выкл.,выкл.)  Allow httpd to can network relay
```

What allows the selinux boolean `httpd_can_network_connect`?
```shell
sesearch -A -b httpd_can_network_connect
```
<details><summary>output</summary>
<p>

```log
Found 31 semantic av rules:
   allow httpd_sys_script_t httpd_sys_script_t : tcp_socket { ioctl read write create getattr setattr lock append bind connect listen accept getopt setopt shutdown } ; 
   allow httpd_sys_script_t port_type : udp_socket recv_msg ; 
   allow httpd_sys_script_t port_type : udp_socket send_msg ; 
   allow httpd_suexec_t httpd_suexec_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow httpd_suexec_t node_t : node { udp_recv recvfrom } ; 
   allow httpd_suexec_t node_t : node { udp_send sendto } ; 
   allow httpd_suexec_t node_t : node { tcp_recv tcp_send recvfrom sendto } ; 
   allow httpd_suexec_t netif_t : netif { udp_recv ingress } ; 
   allow httpd_suexec_t netif_t : netif { udp_send egress } ; 
   allow httpd_suexec_t netif_t : netif { tcp_recv tcp_send ingress egress } ; 
   allow httpd_sys_script_t httpd_sys_script_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow httpd_suexec_t port_type : udp_socket recv_msg ; 
   allow httpd_suexec_t port_type : udp_socket send_msg ; 
   allow httpd_sys_script_t client_packet_type : packet recv ; 
   allow httpd_sys_script_t client_packet_type : packet send ; 
   allow httpd_suexec_t port_type : tcp_socket name_connect ; 
   allow httpd_suexec_t port_type : tcp_socket { recv_msg send_msg } ; 
   allow httpd_suexec_t client_packet_type : packet recv ; 
   allow httpd_suexec_t client_packet_type : packet send ; 
   allow httpd_t port_type : tcp_socket name_connect ; 
   allow httpd_sys_script_t netif_t : netif { udp_recv ingress } ; 
   allow httpd_sys_script_t netif_t : netif { udp_send egress } ; 
   allow httpd_sys_script_t netif_t : netif { tcp_recv tcp_send ingress egress } ; 
   allow httpd_sys_script_t node_t : tcp_socket node_bind ; 
   allow httpd_suexec_t httpd_suexec_t : tcp_socket { ioctl read write create getattr setattr lock append bind connect listen accept getopt setopt shutdown } ; 
   allow httpd_sys_script_t node_t : udp_socket node_bind ; 
   allow httpd_sys_script_t node_t : node { udp_recv recvfrom } ; 
   allow httpd_sys_script_t node_t : node { udp_send sendto } ; 
   allow httpd_sys_script_t node_t : node { tcp_recv tcp_send recvfrom sendto } ; 
   allow httpd_sys_script_t port_type : tcp_socket name_connect ; 
   allow httpd_sys_script_t port_type : tcp_socket { recv_msg send_msg } ;
```
</p>
</details>

Enable seboolean `httpd_can_network_connect`
```shell
setsebool -P httpd_can_network_connect on
```

NOTE: It isn't work with `unreserved_port_t` selinux type (domain), ex.: `8088`.

NOTE: It isn't necessary for port `8080` because on port `8080` nginx already works without any manipulations with selinux.


List allowed rules for `http_cache_port_t`
```shell
sesearch -t http_cache_port_t -s httpd_t -Ad
```
```log
Found 2 semantic av rules:
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_connect ;
```

## Implementation

## TODO

- [ ] Set selinux mode `enforcement`
- [ ] Test nginx on port `8080`
- [ ] Describe and test 3 different ways
   - [ ] `setsebool` switch;
   - [ ] add an alternative port to existing `type`;
   - [ ] develop and install `selinux module`;
