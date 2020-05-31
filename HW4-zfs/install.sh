#!/bin/sh

set -ex

echo "Prepare"
sudo yum install -y epel-release
sudo yum install -y dkms parallel unzip
sudo yum localinstall -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
sudo gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux

echo "Install (it can take a long time on weak machine)"
sudo yum install -y zfs
