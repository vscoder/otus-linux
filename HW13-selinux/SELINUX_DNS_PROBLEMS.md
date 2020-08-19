# Task 2: selinux dns problems

## The Task

Ensure that the application works when selinux is enabled
   - deploy attached [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems);
   - find out why the DNS zone refresh functionality isn't working;
   - suggest a solution to the problem;
   - choose one of the solutions, justify the choice of a solution;
   - implement the solution and make a demo
Expected result:
- README with a description of the broken functionality analyse, an available solutions and a justifycation of choosed solution;
- A fixed `test environment` or a demo of the proper DNS zone refresh functionality whth a screenshots and a description.

## Environment

1. Copy [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems) to `./selinux_dns_problems`
2. Up environment
   ```shell
   cd ./selinux_dns_problems
   vagrant up
   ```
3. List hosts
   ```shell
   vagrant status
   ```
   ```log
   Current machine states:

   ns01                      running (virtualbox)
   client                    running (virtualbox)
   ```

## Ensure problem exists

Check zone
```shell
dig @192.168.50.10 ns01.dns.lab
```
<details><summary>output</summary>
<p>

```log
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-16.P2.el7_8.6 <<>> @192.168.50.10 ns01.dns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6196
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;ns01.dns.lab.                  IN      A

;; ANSWER SECTION:
ns01.dns.lab.           3600    IN      A       192.168.50.10

;; AUTHORITY SECTION:
dns.lab.                3600    IN      NS      ns01.dns.lab.

;; Query time: 3 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Wed Aug 19 22:49:58 UTC 2020
;; MSG SIZE  rcvd: 71
```
</p>
</details>

---

Try update zone
```shell
nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
```
```log
update failed: SERVFAIL
```

---

Add playbook [test.yml](./selinux_dns_problems/provisioning/test.yml) to provision
```yaml
- name: Run tests
  import_playbook: test.yml
```

---

Retry provisioning. On host:
```shell
vagrant provision
```
<details><summary>output</summary>
<p>

```log
...
PLAY [Test nsupdate from client] ***********************************************

TASK [Gathering Facts] *********************************************************
ok: [client]

TASK [Run nsupdate] ************************************************************
changed: [client]

TASK [Check output] ************************************************************
ok: [client] => {
    "nsupdate": {
        "changed": true,
        "cmd": "cat <<EOF | nsupdate -k /etc/named.zonetransfer.key\nserver 192.168.50.10\nzone ddns.lab\nupdate add www.ddns.lab. 60 A 192.168.50.15\nsend\n",
        "delta": "0:00:00.019634",
        "end": "2020-08-19 22:56:20.303103",
        "failed": false,
        "failed_when_result": false,
        "msg": "non-zero return code",
        "rc": 2,
        "start": "2020-08-19 22:56:20.283469",
        "stderr": "/bin/sh: line 4: warning: here-document at line 0 delimited by end-of-file (wanted `EOF')\nupdate failed: SERVFAIL",
        "stderr_lines": [
            "/bin/sh: line 4: warning: here-document at line 0 delimited by end-of-file (wanted `EOF')",
            "update failed: SERVFAIL"
        ],
        "stdout": "",
        "stdout_lines": []
    }
}

PLAY RECAP *********************************************************************
client                     : ok=10   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
</p>
</details>
There is an error:
```log

```

## Analyse

Set SELinux mode to `permissive` and retry `nsupdate`

On `ns01`
```shell
[root@ns01 vagrant]# setenforce 0
[root@ns01 vagrant]# getenforce 
Permissive
```

On host:
```shell
vagrant provision
```
<details><summary>output</summary>
<p>

```log
...

TASK [Run nsupdate] ************************************************************
changed: [client]

TASK [Check output] ************************************************************
ok: [client] => {
    "nsupdate": {
        "changed": true,
        "cmd": "cat <<EOF | nsupdate -k /etc/named.zonetransfer.key\nserver 192.168.50.10\nzone ddns.lab\nupdate add www.ddns.lab. 60 A 192.168.50.15\nsend\nEOF\n",
        "delta": "0:00:00.025792",
        "end": "2020-08-19 23:03:20.353296",
        "failed": false,
        "failed_when_result": false,
        "rc": 0,
        "start": "2020-08-19 23:03:20.327504",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "",
        "stdout_lines": []
    }
}

PLAY RECAP *********************************************************************
client                     : ok=10   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
</p>
</details>
There is no errors

---

Run `sealert` on `ns01`
```shell
LANG=C sealert -a /var/log/audit/audit.log
```
<details><summary>output</summary>
<p>

```shell
100% done
found 3 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/named from search access on the directory net.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that named should be allowed search access on the net directory by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000
# semodule -i my-iscworker0000.pp


Additional Information:
Source Context                system_u:system_r:named_t:s0
Target Context                system_u:object_r:sysctl_net_t:s0
Target Objects                net [ dir ]
Source                        isc-worker0000
Source Path                   /usr/sbin/named
Port                          <Unknown>
Host                          <Unknown>
Source RPM Packages           bind-9.11.4-16.P2.el7_8.6.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-229.el7_6.12.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Permissive
Host Name                     ns01
Platform                      Linux ns01 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue
                              May 14 21:24:32 UTC 2019 x86_64 x86_64
Alert Count                   7
First Seen                    2020-08-19 22:29:55 UTC
Last Seen                     2020-08-19 23:03:13 UTC
Local ID                      f19f14e8-8306-4c1c-ae94-ed6ba5c46184

Raw Audit Messages
type=AVC msg=audit(1597878193.955:6584): avc:  denied  { search } for  pid=16569 comm="isc-worker0000" name="net" dev="proc" ino=33588 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=dir permissive=1


type=AVC msg=audit(1597878193.955:6584): avc:  denied  { read } for  pid=16569 comm="isc-worker0000" name="ip_local_port_range" dev="proc" ino=75599 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=file permissive=1


type=AVC msg=audit(1597878193.955:6584): avc:  denied  { open } for  pid=16569 comm="isc-worker0000" path="/proc/sys/net/ipv4/ip_local_port_range" dev="proc" ino=75599 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=file permissive=1


type=SYSCALL msg=audit(1597878193.955:6584): arch=x86_64 syscall=open success=yes exit=EAGAIN a0=7fae5c22c760 a1=0 a2=1b6 a3=24 items=0 ppid=16567 pid=16569 auid=4294967295 uid=25 gid=25 euid=25 suid=25 fsuid=25 egid=25 sgid=25 fsgid=25 tty=(none) ses=4294967295 comm=isc-worker0000 exe=/usr/sbin/named subj=system_u:system_r:named_t:s0 key=(null)

Hash: isc-worker0000,named_t,sysctl_net_t,dir,search

--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/named from create access on the file named.ddns.lab.view1.jnl.

*****  Plugin catchall_labels (83.8 confidence) suggests   *******************

If you want to allow named to have create access on the named.ddns.lab.view1.jnl file
Then you need to change the label on named.ddns.lab.view1.jnl
Do
# semanage fcontext -a -t FILE_TYPE 'named.ddns.lab.view1.jnl'
where FILE_TYPE is one of the following: dnssec_trigger_var_run_t, ipa_var_lib_t, krb5_host_rcache_t, krb5_keytab_t, named_cache_t, named_log_t, named_tmp_t, named_var_run_t, named_zone_t.
Then execute:
restorecon -v 'named.ddns.lab.view1.jnl'


*****  Plugin catchall (17.1 confidence) suggests   **************************

If you believe that named should be allowed create access on the named.ddns.lab.view1.jnl file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000
# semodule -i my-iscworker0000.pp


Additional Information:
Source Context                system_u:system_r:named_t:s0
Target Context                system_u:object_r:etc_t:s0
Target Objects                named.ddns.lab.view1.jnl [ file ]
Source                        isc-worker0000
Source Path                   /usr/sbin/named
Port                          <Unknown>
Host                          <Unknown>
Source RPM Packages           bind-9.11.4-16.P2.el7_8.6.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-229.el7_6.12.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Permissive
Host Name                     ns01
Platform                      Linux ns01 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue
                              May 14 21:24:32 UTC 2019 x86_64 x86_64
Alert Count                   4
First Seen                    2020-08-19 22:51:02 UTC
Last Seen                     2020-08-19 23:03:20 UTC
Local ID                      a1a92fab-0259-48e9-96ec-7c0113ffd637

Raw Audit Messages
type=AVC msg=audit(1597878200.349:6596): avc:  denied  { create } for  pid=16569 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=1


type=AVC msg=audit(1597878200.349:6596): avc:  denied  { write } for  pid=16569 comm="isc-worker0000" path="/etc/named/dynamic/named.ddns.lab.view1.jnl" dev="sda1" ino=301 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=1


type=SYSCALL msg=audit(1597878200.349:6596): arch=x86_64 syscall=open success=yes exit=ENXIO a0=7fae5da77050 a1=241 a2=1b6 a3=24 items=0 ppid=1 pid=16569 auid=4294967295 uid=25 gid=25 euid=25 suid=25 fsuid=25 egid=25 sgid=25 fsgid=25 tty=(none) ses=4294967295 comm=isc-worker0000 exe=/usr/sbin/named subj=system_u:system_r:named_t:s0 key=(null)

Hash: isc-worker0000,named_t,etc_t,file,create

--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/named from getattr access on the file /proc/sys/net/ipv4/ip_local_port_range.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that named should be allowed getattr access on the ip_local_port_range file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000
# semodule -i my-iscworker0000.pp


Additional Information:
Source Context                system_u:system_r:named_t:s0
Target Context                system_u:object_r:sysctl_net_t:s0
Target Objects                /proc/sys/net/ipv4/ip_local_port_range [ file ]
Source                        isc-worker0000
Source Path                   /usr/sbin/named
Port                          <Unknown>
Host                          <Unknown>
Source RPM Packages           bind-9.11.4-16.P2.el7_8.6.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-229.el7_6.12.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Permissive
Host Name                     ns01
Platform                      Linux ns01 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue
                              May 14 21:24:32 UTC 2019 x86_64 x86_64
Alert Count                   1
First Seen                    2020-08-19 23:03:13 UTC
Last Seen                     2020-08-19 23:03:13 UTC
Local ID                      f377bbdc-8edf-4219-85f9-ac416ff7685c

Raw Audit Messages
type=AVC msg=audit(1597878193.955:6585): avc:  denied  { getattr } for  pid=16569 comm="isc-worker0000" path="/proc/sys/net/ipv4/ip_local_port_range" dev="proc" ino=75599 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=file permissive=1


type=SYSCALL msg=audit(1597878193.955:6585): arch=x86_64 syscall=fstat success=yes exit=0 a0=b a1=7fae597c8240 a2=7fae597c8240 a3=7fae597c81a0 items=0 ppid=16567 pid=16569 auid=4294967295 uid=25 gid=25 euid=25 suid=25 fsuid=25 egid=25 sgid=25 fsgid=25 tty=(none) ses=4294967295 comm=isc-worker0000 exe=/usr/sbin/named subj=system_u:system_r:named_t:s0 key=(null)

Hash: isc-worker0000,named_t,sysctl_net_t,file,getattr
```
</p>
</details>
There is 3 problems:

1. > SELinux is preventing /usr/sbin/named from search access on the directory net.
2. > SELinux is preventing /usr/sbin/named from create access on the file named.ddns.lab.view1.jnl.
3. > SELinux is preventing /usr/sbin/named from getattr access on the file /proc/sys/net/ipv4/ip_local_port_range.
