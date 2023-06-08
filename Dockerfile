FROM node:20-alpine as linter

WORKDIR /var/www/it.labs/

RUN npm i create-stylelint && \
    npm init stylelint

COPY src/ .

FROM nginx:1.23-alpine

COPY src/ /var/www/it.labs/
COPY conf.d/ /etc/nginx/conf.d
