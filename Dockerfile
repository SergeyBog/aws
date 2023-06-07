FROM nginx:1.23-alpine

COPY src/ /var/www/it.labs/
COPY conf.d/ /etc/nginx/conf.d
