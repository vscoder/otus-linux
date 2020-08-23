# nginx

Here is presented docker container with nginx

## How to configure

Copy `.env.example` file to `.env` and update variables:
- container environment variables:
  - `NGINX_DEFAULT_SITE_PORT` port to nginx container listen to (`listen` directive value)
  - `NGINX_STATIC_ROOT` root directory for nginx sites (`root` directive value)
- compose-related variables
  - `IMAGE_NAME` docker image name
  - `IMAGE_VERSION` docker image tag

There is two directories:
- The 1st is `./context/conf.d`. Content of this directory will be placed to `/etc/nginx/conf.d`
- The 2nd is `./context/www`. Content of this directory will be placed to `${NGINX_STATIC_ROOT}` directory

To create static site:
1. Create static site config in `./context/conf.d` with extension `.tmpl`. It's possible to use variables described above.
2. Set static site root to `${NGINX_SITE_ROOT}/static_site_name`
3. Place static site content to `./context/www/static_site_name`

## How to run

Build image
```shell
docker-compose build
```

Run container
```shell
docker-compose up -d
```

Stop container
```shell
docker-compose down
```
