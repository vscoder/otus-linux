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

### Task 1: nginx

[NGINX.md](./NGINX.md)

#### How to test

Update `./roles/ansible-role-nginx/molecule/vagrant-8085/converge.yml` and set to `yes` one of:
- `nginx_selinux_seport` - allow nginx to bind to network port using
  ```shell
  semanage port -a -t http_port_t -p tcp 8085
  ```
- `nginx_selinux_sebool` - use seboolean to allow nginx to bind to port 8085 and many other permissions
  ```shell
  setsebool -P nis_enabled 1
  ```

Don't forget to set other variable to `no`

Then run `make nginx-test`, wait few minutes...

And if you see
```log
    TASK [Ensure nginx works] ******************************************************
    ok: [centos-8] => (item=8082)
    ok: [centos-7] => (item=8082)
    ok: [vscoder-centos-7-5] => (item=8082)
    ok: [centos-8] => (item=8083)
    ok: [centos-7] => (item=8083)
    ok: [vscoder-centos-7-5] => (item=8083)
    ok: [centos-8] => (item=8084)
    ok: [vscoder-centos-7-5] => (item=8084)
    ok: [centos-7] => (item=8084)
```
at the end of process, then nginx works!

### Task 2: selinux dns problem

[SELINUX_DNS_PROBLEMS.md](./SELINUX_DNS_PROBLEMS.md)

### How to test

Run 
```shell
make dns-test
```

Then wait few minutes...

And if you see
```log
TASK [Check output] ************************************************************
ok: [client] => {
    "msg": "nsupdate.rc: 0\nnsupdate.stdout: \nnsupdate.stderr: \n"
}

TASK [Lookup www.ddns.lab.] ****************************************************
changed: [client]

TASK [Lookup result] ***********************************************************
ok: [client] => {
    "msg": "dig.rc: 0\ndig.stdout: \n; <<>> DiG 9.11.4-P2-RedHat-9.11.4-16.P2.el7_8.6 <<>> www.ddns.lab. @192.168.50.10\n;; global options: +cmd\n;; Got answer:\n;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3958\n;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2\n\n;; OPT PSEUDOSECTION:\n; EDNS: version: 0, flags:; udp: 4096\n;; QUESTION SECTION:\n;www.ddns.lab.\t\t\tIN\tA\n\n;; ANSWER SECTION:\nwww.ddns.lab.\t\t60\tIN\tA\t192.168.50.15\n\n;; AUTHORITY SECTION:\nddns.lab.\t\t3600\tIN\tNS\tns01.dns.lab.\n\n;; ADDITIONAL SECTION:\nns01.dns.lab.\t\t3600\tIN\tA\t192.168.50.10\n\n;; Query time: 0 msec\n;; SERVER: 192.168.50.10#53(192.168.50.10)\n;; WHEN: Fri Aug 21 19:38:39 UTC 2020\n;; MSG SIZE  rcvd: 96\ndig.stderr: \n"
}
```
then it's OK!

NOTE: pretty output of `TASK [Lookup result]`:
```log
dig.rc: 0
dig.stdout: 
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-16.P2.el7_8.6 <<>> www.ddns.lab. @192.168.50.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3958
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.                  IN      A

;; ANSWER SECTION:
www.ddns.lab.           60      IN      A       192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.               3600    IN      NS      ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.           3600    IN      A       192.168.50.10

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Fri Aug 21 19:38:39 UTC 2020
;; MSG SIZE  rcvd: 96
dig.stderr: 
```

## Cleanup

Don't forget to do cleanup after tests!
```shell
make clean
```
