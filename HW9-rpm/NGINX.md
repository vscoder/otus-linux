# Build and install nginx

- [Build and install nginx](#build-and-install-nginx)
  - [Prepare](#prepare)
  - [Get sources](#get-sources)
  - [Prepare](#prepare-1)
  - [Build](#build)
  - [Install](#install)
  - [Run](#run)
  - [Provision](#provision)

## Prepare

There need next packages for the task.
```shell
sudo yum install -y \
   redhat-lsb-core \
   wget \
   rpmdevtools \
   rpm-build \
   createrepo \
   yum-utils
```
[output](./logs/install-necessary.log)

Let's take `nginx` package for example and build it with `openssl` support.


## Get sources

Fetch SRPM `nginx` package (latest version `v1.18.0-1.el7`)
```shell
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.18.0-1.el7.ngx.src.rpm
```
<details><summary>output</summary>
<p>

```log
--2020-06-21 18:10:56--  https://nginx.org/packages/centos/7/SRPMS/nginx-1.18.0-1.el7.ngx.src.rpm
Распознаётся nginx.org (nginx.org)... 62.210.92.35, 95.211.80.227, 2001:1af8:4060:a004:21::e3
Подключение к nginx.org (nginx.org)|62.210.92.35|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа... 200 OK
Длина: 1059854 (1,0M) [application/x-redhat-package-manager]
Сохранение в: «nginx-1.18.0-1.el7.ngx.src.rpm»

100%[========================================================================================================================>] 1 059 854   1,25MB/s   за 0,8s   

2020-06-21 18:10:57 (1,25 MB/s) - «nginx-1.18.0-1.el7.ngx.src.rpm» сохранён [1059854/1059854]
```
</p>
</details>

There created special directory structure with installation of SRPM package:
```shell
rpm -i nginx-1.18.0-1.el7.ngx.src.rpm
```
<details><summary>output</summary>
<p>

```log
предупреждение: nginx-1.18.0-1.el7.ngx.src.rpm: Заголовок V4 RSA/SHA1 Signature, key ID 7bd9bf62: NOKEY
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
предупреждение: пользователь builder не существует - используется root
предупреждение: группа builder не существует - используется root
```
</p>
</details>

Directory structure:
```shell
tree ./rpmbuild/
```
<details><summary>output</summary>
<p>

```log
./rpmbuild/
├── SOURCES
│   ├── COPYRIGHT
│   ├── logrotate
│   ├── nginx-1.18.0.tar.gz
│   ├── nginx.check-reload.sh
│   ├── nginx.conf
│   ├── nginx-debug.service
│   ├── nginx-debug.sysconf
│   ├── nginx.init.in
│   ├── nginx.service
│   ├── nginx.suse.logrotate
│   ├── nginx.sysconf
│   ├── nginx.upgrade.sh
│   └── nginx.vh.default.conf
└── SPECS
    └── nginx.spec

2 directories, 14 files
```
</p>
</details>

Also it's necessary to download and extract the latest `openssl` sources
```shell
wget https://www.openssl.org/source/latest.tar.gz
```
<details><summary>output</summary>
<p>

```log
--2020-06-21 18:25:49--  https://www.openssl.org/source/latest.tar.gz
Распознаётся www.openssl.org (www.openssl.org)... 104.75.67.249, 2a02:2d8:3:9b1::c1e, 2a02:2d8:3:9a8::c1e
Подключение к www.openssl.org (www.openssl.org)|104.75.67.249|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа... 302 Moved Temporarily
Адрес: https://www.openssl.org/source/openssl-1.1.1g.tar.gz [переход]
--2020-06-21 18:25:50--  https://www.openssl.org/source/openssl-1.1.1g.tar.gz
Повторное использование соединения с www.openssl.org:443.
HTTP-запрос отправлен. Ожидание ответа... 200 OK
Длина: 9801502 (9,3M) [application/x-gzip]
Сохранение в: «latest.tar.gz»

100%[========================================================================================================================>] 9 801 502   10,2MB/s   за 0,9s   

2020-06-21 18:25:51 (10,2 MB/s) - «latest.tar.gz» сохранён [9801502/9801502]
```
</p>
</details>

Extract `openssl`
```shell
tar -xvf latest.tar.gz
```
[output](./logs/extract-openssl.log)

## Prepare

Build dependencies
```shell
sudo yum-builddep --verbose --assumeyes rpmbuild/SPECS/nginx.spec
```
[output](./logs/builddep.log)

Fix nginx.spec
```shell
sed -i 's#--with-debug#--with-openssl=/home/vagrant/openssl-1.1.1g#g' rpmbuild/SPECS/nginx.spec
```

## Build

Now build nginx and create RPM packages
```shell
rpmbuild -bb rpmbuild/SPECS/nginx.spec
```
[output](./logs/rpmbuild.log)

Check result
```shell
ls -l rpmbuild/RPMS/x86_64/
```
```log
итого 3848
-rw-rw-r-- 1 vagrant vagrant 2022120 июн 24 08:27 nginx-1.18.0-1.el7.ngx.x86_64.rpm
-rw-rw-r-- 1 vagrant vagrant 1915268 июн 24 08:27 nginx-debuginfo-1.18.0-1.el7.ngx.x86_64.rpm
```

## Install

Now we can install builded package and ensure it works.
```shell
sudo yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.18.0-1.el7.ngx.x86_64.rpm 
```
<details><summary>output</summary>
<p>

```log
Загружены модули: fastestmirror
Проверка rpmbuild/RPMS/x86_64/nginx-1.18.0-1.el7.ngx.x86_64.rpm: 1:nginx-1.18.0-1.el7.ngx.x86_64
rpmbuild/RPMS/x86_64/nginx-1.18.0-1.el7.ngx.x86_64.rpm отмечен для установки
Разрешение зависимостей
--> Проверка сценария
---> Пакет nginx.x86_64 1:1.18.0-1.el7.ngx помечен для установки
--> Проверка зависимостей окончена

Зависимости определены

==================================================================================================================================================================
 Package                      Архитектура                   Версия                                    Репозиторий                                           Размер
==================================================================================================================================================================
Установка:
 nginx                        x86_64                        1:1.18.0-1.el7.ngx                        /nginx-1.18.0-1.el7.ngx.x86_64                        5.9 M

Итого за операцию
==================================================================================================================================================================
Установить  1 пакет

Общий размер: 5.9 M
Объем изменений: 5.9 M
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Установка   : 1:nginx-1.18.0-1.el7.ngx.x86_64                                                                                                               1/1 
----------------------------------------------------------------------

Thanks for using nginx!

Please find the official documentation for nginx here:
* http://nginx.org/en/docs/

Please subscribe to nginx-announce mailing list to get
the most important news about nginx:
* http://nginx.org/en/support.html

Commercial subscriptions for nginx are available on:
* http://nginx.com/products/

----------------------------------------------------------------------
  Проверка    : 1:nginx-1.18.0-1.el7.ngx.x86_64                                                                                                               1/1 

Установлено:
  nginx.x86_64 1:1.18.0-1.el7.ngx                                                                                                                                 

Выполнено!
```
</p>
</details>

Check
```shell
nginx -v
```
```log
nginx version: nginx/1.18.0
```

## Run

Run nginx service
```shell
sudo systemctl start nginx
systemctl status nginx
```
```log
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Ср 2020-06-24 08:34:02 UTC; 9s ago
     Docs: http://nginx.org/en/docs/
  Process: 841 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 842 (nginx)
   CGroup: /system.slice/nginx.service
           ├─842 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           └─843 nginx: worker process
```

Check
```shell
curl -I localhost
```
```log
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Wed, 24 Jun 2020 08:36:03 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Wed, 24 Jun 2020 08:27:20 GMT
Connection: keep-alive
ETag: "5ef30e68-264"
Accept-Ranges: bytes
```

## Provision

There is vagrant [provision script](./provision/1-nginx.sh)
