#!/bin/bash

set -eux

ROLE="$1"

echo Configure firewalld
case "$ROLE" in
"server")
    echo Configuring NFS server
;;
"client")
    echo Configuring NFS client
;;
*)
    echo "Usage: $0 <server|client>"
    exit 1
;;
esac


echo "Enable firewall"
systemctl enable firewalld
systemctl start firewalld
systemctl status firewalld
