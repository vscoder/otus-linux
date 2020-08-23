#!/bin/sh

set -eu

# Generate nginx site config from template
cd /etc/nginx/conf.d
/usr/bin/envsubst <./site.conf.tmpl | tee "${NGINX_SITE_NAME}.conf"
rm -f ./site.conf.env

# Create pid file directory
mkdir -p /run/nginx

exec "$@"
