# nginx

Here is presented docker container with nginx

## How to configure

Copy `.env.example` file to `.env` and update variables:
- container environment variables:
  - `NGINX_SITE_PORT` port to nginx container listen to (`listen` directive value)
  - `NGINX_SITE_ROOT` root directory for nginx sites (`root` directive value)
  - `NGINX_SITE_NAME` nginx site name (`server_name` directive value)
- compose-related variables
  - `IMAGE_NAME` docker image name
  - `IMAGE_VERSION` docker image tag

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
