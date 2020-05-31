#!/bin/bash

echo Get test data
cd ~
test -f enwik8.zip || wget http://mattmahoney.net/dc/enwik8.zip
test -f enwik8 || unzip enwik8.zip
ll enwik8*

echo Copy test data to volumes
cd ~
echo -n gzip gzip-{1..9} lz4 lzjb zle | parallel -d" " sudo cp enwik8 /zpool/{}/

echo Get compressration
echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs get compressratio zpool/{} | grep compressratio
