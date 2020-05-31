#!/bin/sh

set -ex

echo Ensure module is mounted
sudo /sbin/modprobe zfs

echo Create zfs pool named zpool with cache
sudo zpool create zpool sdb cache sdc
sudo zpool status

echo Create zpools with different compression algorithms
echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs create -o compression={} zpool/{}
sudo zfs list
