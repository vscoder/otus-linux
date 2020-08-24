FROM nginx:1.18.0-alpine

LABEL maintainer="Aleksey Koloskov <vsyscoder@gmail.com>"

# Remove default site config
RUN rm /etc/nginx/conf.d/default.conf

# Copy config templates
COPY templates /etc/nginx/templates
# Copy static content
COPY www ${NGINX_STATIC_ROOT}
