# HomeWork 12: Authentication Authorization Accounting

## Tasks

1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
2. ✱ дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

---

1. Deny login at weekend (Saturday and Sunday
) for all users except group `admin` (excluding holidays)
2. ✱ Allow a specific user to work with docker and to restart docker service

## Information

- What is PAM? https://medium.com/information-and-technology/wtf-is-pam-99a16c80ac57
- Основы настройки PAM. https://www.ibm.com/developerworks/ru/library/l-pam/index.html
- Как работает PAM. https://www.opennet.ru/base/net/pam_linux.txt.html
- pam_time module Man Page https://www.systutorials.com/docs/linux/man/8-pam_time/

## Implmentation

1. Using `pam_time` [roles/ansible-role-pamtime/](./roles/ansible-role-pamtime/). Usable only when restrict access for users, not usergroups.
2. Using `pam_exec` [./roles/ansible-role-pamexec/](./roles/ansible-role-pamexec/).

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

There would be created two users:
- `testuser` member of group `users`
- `testadmin` member of group `admin`

Also user `vagrant` would be added to group `admin` as not to lose possibility to connect at weekend.

## How to test

Today is 2020-08-01 (Saturday)

Try to connect as `testadmin`
```shell
ssh -i ./.vagrant/machines/hw12-aaa/virtualbox/private_key -p 2222 testadmin@127.0.0.1
```
Success
```log
[testadmin@hw12-aaa ~]$ logout
Connection to 127.0.0.1 closed.
```

Try to connect as `testuser`
```shell
ssh -i ./.vagrant/machines/hw12-aaa/virtualbox/private_key -p 2222 testuser@127.0.0.1 
```
```log
/usr/local/bin/check-week-day.sh failed: exit code 1
Connection closed by 127.0.0.1 port 2222
```

## Problems

Problem: `pam_time` module isn't work with groupnames, only usernames allowed
Solution: use other module, ex. `pam_exec`
