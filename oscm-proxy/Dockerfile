FROM nginx:1.18.0-alpine

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    apk update && \
    apk add bash && \
    apk add vim && \
    mkdir /etc/nginx/certs && \
    mkdir /etc/nginx/certs/privkey && \
    mkdir /etc/nginx/certs/chain && \
    mkdir /etc/nginx/certs/cert
    
COPY resources/app.conf /etc/nginx/


EXPOSE 80 443

