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
