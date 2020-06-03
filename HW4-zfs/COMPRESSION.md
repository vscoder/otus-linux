# The best compression algorithm

## Documentation

Getting started https://openzfs.github.io/openzfs-docs/Getting%20Started/RHEL%20and%20CentOS.html

## Installation

Add repository
```shell
yum install -y epel-release
yum install -y dkms
yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
```

Install and wait for dkms compile module
```shell
sudo yum install -y zfs
```
[output](./logs/zfs-install.log)

All these steps are described in [install.sh](./install.sh) and which can be executed via
```shell
cat install.sh | vagrant ssh -c "bash"
```

## Create ZFS and volumes

Load module
```shell
sudo /sbin/modprobe zfs
```

Create zfs pool named `zpool` on `/dev/sdb` with cache on `/dev/sdc`
```shell
sudo zpool create zpool sdb cache sdc
sudo zpool status
```
```log
  pool: zpool
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        zpool       ONLINE       0     0     0
          sdb       ONLINE       0     0     0
        cache
          sdc       ONLINE       0     0     0

errors: No known data errors
```

Create volumes with compression
```shell
echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs create -o compression={} zpool/{}
sudo zfs list
```
```log
NAME           USED  AVAIL     REFER  MOUNTPOINT
zpool          564K  9.20G       27K  /zpool
zpool/gzip      24K  9.20G       24K  /zpool/gzip
zpool/gzip-1    24K  9.20G       24K  /zpool/gzip-1
zpool/gzip-2    24K  9.20G       24K  /zpool/gzip-2
zpool/gzip-3    24K  9.20G       24K  /zpool/gzip-3
zpool/gzip-4    24K  9.20G       24K  /zpool/gzip-4
zpool/gzip-5    24K  9.20G       24K  /zpool/gzip-5
zpool/gzip-6    24K  9.20G       24K  /zpool/gzip-6
zpool/gzip-7    24K  9.20G       24K  /zpool/gzip-7
zpool/gzip-8    24K  9.20G       24K  /zpool/gzip-8
zpool/gzip-9    24K  9.20G       24K  /zpool/gzip-9
zpool/lz4       24K  9.20G       24K  /zpool/lz4
zpool/lzjb      24K  9.20G       24K  /zpool/lzjb
zpool/zle       24K  9.20G       24K  /zpool/zle
```

Get compression alorithms
```shell
echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs get compression zpool/{} | grep compression
```
```log
zpool/gzip  compression  gzip      local
zpool/gzip-1  compression  gzip-1    local
zpool/gzip-2  compression  gzip-2    local
zpool/gzip-3  compression  gzip-3    local
zpool/gzip-4  compression  gzip-4    local
zpool/gzip-5  compression  gzip-5    local
zpool/gzip-6  compression  gzip      local
zpool/gzip-7  compression  gzip-7    local
zpool/gzip-8  compression  gzip-8    local
zpool/gzip-9  compression  gzip-9    local
zpool/lz4  compression  lz4       local
zpool/lzjb  compression  lzjb      local
zpool/zle  compression  zle       local
```

Little cheat: how to destroy all volumes
```shell
sudo zfs list | grep zpool/ | awk '{ print $1 }' | xargs -I{} sudo zfs destroy {}
```

All these steps are described in [create.sh](./create.sh) and which can be executed via
```shell
cat create.sh | vagrant ssh -c "bash"
```

## Test compression ratio

Get test data
```shell
{
    cd ~
    wget http://mattmahoney.net/dc/enwik8.zip
    unzip enwik0.zip
    ll enwik8*
}
```
<details><summary>output</summary>
<p>

```log
--2020-05-31 22:55:42--  http://mattmahoney.net/dc/enwik8.zip
Resolving mattmahoney.net (mattmahoney.net)... 67.195.197.75
Connecting to mattmahoney.net (mattmahoney.net)|67.195.197.75|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 36445475 (35M) [application/zip]
Saving to: ‘enwik8.zip’

100%[========================================================================================================================>] 36,445,475   491KB/s   in 81s    

2020-05-31 22:57:03 (440 KB/s) - ‘enwik8.zip’ saved [36445475/36445475]

Archive:  enwik8.zip
  inflating: enwik8                  
-rw-rw-r-- 1 vagrant vagrant 100000000 Jun  1  2011 enwik8
-rw-rw-r-- 1 vagrant vagrant  36445475 Sep  1  2011 enwik8.zip
```
</p>
</details>

Copy test data to volumes
```shell
cd ~
echo -n gzip gzip-{1..9} lz4 lzjb zle | parallel -d" " sudo cp enwik8 /zpool/{}/
```

Get compressratio
```shell
echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs get compressratio zpool/{} | grep compressratio
```
```log
zpool/gzip  compressratio  2.66x  -
zpool/gzip-1  compressratio  2.32x  -
zpool/gzip-2  compressratio  2.40x  -
zpool/gzip-3  compressratio  2.47x  -
zpool/gzip-4  compressratio  2.57x  -
zpool/gzip-5  compressratio  2.64x  -
zpool/gzip-6  compressratio  2.66x  -
zpool/gzip-7  compressratio  2.66x  -
zpool/gzip-8  compressratio  2.66x  -
zpool/gzip-9  compressratio  2.66x  -
zpool/lz4  compressratio  1.72x  -
zpool/lzjb  compressratio  1.44x  -
zpool/zle  compressratio  1.00x  -
```

The best are `gzip` and `gzip-{6..9}`. But they may be not the fastest ;)

All these steps are described in [test-compression.sh](./test-compression.sh) and which can be executed via
```shell
cat test-compression.sh | vagrant ssh -c "bash"
```
