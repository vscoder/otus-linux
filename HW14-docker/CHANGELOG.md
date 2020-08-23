## 2020-08-23

- Start the HomeWork
- Add `README.md`
- Answer the questions 2 and 3 in `README.md`
- Add `./docker` directory
- Create `./docker/context` directory with docker context including `Dockerfile`
- Create `./docker/docker-compose.yml` file to build image and run container
- Create `./docker/README.md` with instructions how to configure, build, run and clean.
- Move `./docker/context/site.conf.tmpl` to `./docker/context/conf.d/site.conf.tmpl`
- Copy `./docker/context/conf.d/` into docker container `/etc/nginx/conf.d/`
- Move `./docker/context/site-content/index.html` to `./docker/context/www/default/index.html`
- Rename `./docker/context/conf.d/site.conf.tmpl` to `./docker/context/conf.d/default.conf.tmpl`
- Update entrypoint. Use `envsupst` for all config templates in `./docker/context/conf.d/*.tmpl`/ Rename templates to corresponding `.conf` files
