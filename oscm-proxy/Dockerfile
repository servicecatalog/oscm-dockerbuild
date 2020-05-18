FROM nginx:1.18.0-alpine

COPY start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    apk update && \
    apk add bash && \
    apk add vim && \
    apk add apache2-utils && \
    mkdir /etc/nginx/certs && \
    mkdir /etc/nginx/certs/privkey && \
    mkdir /etc/nginx/certs/chain && \
    mkdir /etc/nginx/certs/cert && \
    mkdir /etc/nginx/pwd && \
    chmod +x /opt/start.sh

EXPOSE 80 443

CMD ["/opt/start.sh"]