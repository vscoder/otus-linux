FROM alpine:3.12.0

LABEL maintainer="Aleksey Koloskov <vsyscoder@gmail.com>"

# nginx version to install (must be available in )
ARG NGINX_VERSION=1.18.0-r0
ARG GETTEXT_VERSION=0.20.2-r0

# nginx site-related variables
ENV NGINX_SITE_PORT=8080
ENV NGINX_SITE_ROOT=/data/www
ENV NGINX_SITE_NAME=site

# Install nginx
RUN apk update && \
    apk add --no-cache \
    gettext==${GETTEXT_VERSION} \
    nginx==${NGINX_VERSION}

# Ensure sites directory exists
RUN mkdir -p ${NGINX_SITE_ROOT}

# Copy site content
COPY site-content ${NGINX_SITE_ROOT}/${NGINX_SITE_NAME}
# Copy nginx site config template
COPY site.conf.tmpl /etc/nginx/conf.d/

# Provide entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE ${NGINX_SITE_PORT}

CMD ["nginx", "-g", "daemon off;"]
