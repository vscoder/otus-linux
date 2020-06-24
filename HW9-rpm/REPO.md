# Create own RPM repository

## Prepare repo directory

Nginx has directory for static files `/usr/share/nginx/html/` by default.

Create `repo` directory there
```shell
sudo mkdir -p /usr/share/nginx/html/repo
```

Copy nginx rpm to repo directory
```shell
sudo cp rpmbuild/RPMS/x86_64/nginx-1.18.0-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
```

Also fetch percona server
```shell
sudo wget -q http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
```

## Create repository

Create repository with `createrepo` command
```shell
sudo createrepo /usr/share/nginx/html/repo/
```
<details><summary>output</summary>
<p>

```log
Spawning worker 0 with 1 pkgs
Spawning worker 1 with 1 pkgs
Spawning worker 2 with 0 pkgs
Spawning worker 3 with 0 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
```
</p>
</details>

Repository directory structure
```shell
tree /usr/share/nginx/html/repo/
```
<details><summary>output</summary>
<p>

```log
/usr/share/nginx/html/repo/
├── nginx-1.18.0-1.el7.ngx.x86_64.rpm
├── percona-release-0.1-6.noarch.rpm
└── repodata
    ├── 3ee366b6d643c5bedcf1e17b10c455f1f4ce60938704bbf0c41720a89163ed59-filelists.sqlite.bz2
    ├── 5459dfa61666067f8da15de595281c7ddb2d67c85bf860e7f0ee741701ab056d-other.sqlite.bz2
    ├── 5c8f283c72eebc13f1dabdf430b4706a68fadf9d386dfbdcc9fbb6e2eb79b7d0-primary.xml.gz
    ├── 6524ce47a12c282b6ba132deb918183f5216cc57a51f4e193ae76c4680bbd982-primary.sqlite.bz2
    ├── a29d879599ccbf765631d406d9df19be7cf53eb241ce6e0e8da971be980112c2-filelists.xml.gz
    ├── d04190f2cd63fcaa9c37027d7d2d385778dc7aa146a4a26d18402517365c32a1-other.xml.gz
    └── repomd.xml

1 directory, 9 files
```
</p>
</details>

## Configure nginx

Add `autoindex on;` to `location /`, then reload nginx.
```shell
sudo sed -i '/index  index.html index.htm;/ a autoindex on;' /etc/nginx/conf.d/default.conf
sudo nginx -t && sudo nginx -s reload
```
```log
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Check result
```shell
curl -a http://localhost/repo/
```
<details><summary>output</summary>
<p>

```html
<html>
<head><title>Index of /repo/</title></head>
<body>
<h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
<a href="repodata/">repodata/</a>                                          24-Jun-2020 10:29                   -
<a href="nginx-1.18.0-1.el7.ngx.x86_64.rpm">nginx-1.18.0-1.el7.ngx.x86_64.rpm</a>                  24-Jun-2020 10:22             2022124
<a href="percona-release-0.1-6.noarch.rpm">percona-release-0.1-6.noarch.rpm</a>                   13-Jun-2018 06:34               14520
</pre><hr></body>
</html>
```
</p>
</details>

## Test repo

Add repo to `/etc/yum.repos.d`
```shell
cat << EOF | sudo tee /etc/yum.repos.d/otus.repo
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
```

Ensure repo is enabled
```shell
yum repolist enabled | grep otus
```
```log
otus  otus-linux  2
```

Reinstall nginx from repo
```shell
sudo yum reinstall nginx --disablerepo="*" --enablerepo=otus
```
[output](./log/../logs/nginx-reinstall.log)

List packages in custom repo
```shell
sudo yum repo-pkgs otus list all
```
```log
Загружены модули: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.sale-dedic.com
 * elrepo: mirror.yandex.ru
 * extras: mirror.reconn.ru
 * updates: mirror.reconn.ru
Установленные пакеты
nginx.x86_64                                  1:1.18.0-1.el7.ngx                        @otus
Доступные пакеты
percona-release.noarch                        0.1-6                                     otus
```
