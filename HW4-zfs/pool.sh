#!/bin/bash

echo Fetch and extract disk image
cd ~
test -f zfsdisk.img.tar.gz || wget -O zfsdisk.img.tar.gz https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download
ls -lah zfsdisk.img.tar.gz
tar xvzf zfsdisk.img.tar.gz

echo "Import zpool from files"
sudo zpool import -d ~/zpoolexport otus
sudo zpool list
