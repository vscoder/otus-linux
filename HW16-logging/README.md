# HomeWork 16: logging

## Tasks

Настраиваем центральный сервер для сбора логов

в вагранте поднимаем 2 машины web и log
- на web поднимаем nginx
- на log настраиваем центральный лог сервер на любой системе на выбор
  - journald
  - rsyslog
  - elk
- настраиваем аудит следящий за изменением конфигов нжинкса

Особенности
- все критичные логи с web должны собираться и локально и удаленно
- все логи с nginx должны уходить на удаленный сервер (локально только критичные)
- логи аудита должны также уходить на удаленную систему

Задание со (*)
- (*) развернуть еще машину elk и таким образом настроить 2 центральных лог системы elk И какую либо еще
  - в elk должны уходить только логи нжинкса
  - во вторую систему все остальное

---

Provide central server for collecting logs

Build vagrant environment with 2 instances:
- `web` with nginx
- `log` with one of log collectors
  - `journald`
  - `rsyslog`
  - `elk`
- on `web` configure audit of nginx's configs

Notes:
- all _critical_ logs from `web` must be collected on local and remote machine
- all nginx's logs be collected only on remote machine, except _critical_ which must have local copy also
- audit logs must be collected on remote host

Task with asterisk (*)
- (*) Up second log server with ELK
  - send nginx's logs only to ELK
  - send all other logs to second log-server

## How to run

## Problems

### Nginx can't connect to kibana

Problem:
```log
2020/09/13 14:35:19 [crit] 9738#9738: *5 connect() to 10.0.2.15:5601 failed (13: Permission denied) while connecting to upstream, client: 10.0.2.2, server: localhost, request: "GET /kibana HTTP/1.1", upstream: "http://10.0.2.15:5601/kibana", host: "localhost:1080"
```

Diagnostic:
- Ensure `setroubleshoot-server` is installed:
  ```shell
  yum install setroubleshoot-server
  ```
- Analyse `audit.log`
  ```shell
  LANG=C sealert -a /var/log/audit/audit.log
  ```
<details><summary>output</summary>
<p>

```log
100% done
found 1 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/nginx from name_connect access on the tcp_socket port 5601.

*****  Plugin connect_ports (85.9 confidence) suggests   *********************

If you want to allow /usr/sbin/nginx to connect to network port 5601
Then you need to modify the port type.
Do
# semanage port -a -t PORT_TYPE -p tcp 5601
    where PORT_TYPE is one of the following: dns_port_t, dnssec_port_t, http_port_t, kerberos_port_t, ocsp_port_t.

*****  Plugin catchall_boolean (7.33 confidence) suggests   ******************

If you want to allow httpd to can network connect
Then you must tell SELinux about this by enabling the 'httpd_can_network_connect' boolean.

Do
setsebool -P httpd_can_network_connect 1

*****  Plugin catchall_boolean (7.33 confidence) suggests   ******************

If you want to allow nis to enabled
Then you must tell SELinux about this by enabling the 'nis_enabled' boolean.

Do
setsebool -P nis_enabled 1

*****  Plugin catchall (1.35 confidence) suggests   **************************

If you believe that nginx should be allowed name_connect access on the port 5601 tcp_socket by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'nginx' --raw | audit2allow -M my-nginx
# semodule -i my-nginx.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                system_u:object_r:unreserved_port_t:s0
Target Objects                port 5601 [ tcp_socket ]
Source                        nginx
Source Path                   /usr/sbin/nginx
Port                          5601
Host                          <Unknown>
Source RPM Packages           nginx-1.19.1-1.el7.ngx.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-266.el7_8.1.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     hw16-web
Platform                      Linux hw16-web 3.10.0-1127.el7.x86_64 #1 SMP Tue
                              Mar 31 23:36:51 UTC 2020 x86_64 x86_64
Alert Count                   11
First Seen                    2020-09-13 14:34:21 UTC
Last Seen                     2020-09-13 14:35:19 UTC
Local ID                      4afb4bd7-2a54-443b-a925-6781fffcb4a0

Raw Audit Messages
type=AVC msg=audit(1600007719.921:4193): avc:  denied  { name_connect } for  pid=9738 comm="nginx" dest=5601 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0


type=SYSCALL msg=audit(1600007719.921:4193): arch=x86_64 syscall=connect success=no exit=EACCES a0=7 a1=56520b678cd8 a2=10 a3=7ffc7e337d20 items=0 ppid=4161 pid=9738 auid=4294967295 uid=997 gid=993 euid=997 suid=997 fsuid=997 egid=993 sgid=993 fsgid=993 tty=(none) ses=4294967295 comm=nginx exe=/usr/sbin/nginx subj=system_u:system_r:httpd_t:s0 key=(null)

Hash: nginx,httpd_t,unreserved_port_t,tcp_socket,name_connect
```
</p>
</details>

Resolve:
```yaml
- name: Allow nginx to connect to upstreams
  seport:
    ports: "{{ item }}"
    proto: tcp
    setype: "{{ nginx_selinux_connect_seport_type }}"
    state: present
  loop: "{{ nginx_selinux_upstream_ports }}"
```
