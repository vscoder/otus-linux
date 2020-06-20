#!/bin/sh

set -eu

echo "Add EPEL repo"
sudo yum install -y epel-release

echo "Install necessary packages"
sudo yum install -y vim-enhanced bash-completion mailx

echo "Create state directory for parser-last.sh"
mkdir /var/spool/nginx_log_analyzer
chown vagrant:vagrant /var/spool/nginx_log_analyzer
