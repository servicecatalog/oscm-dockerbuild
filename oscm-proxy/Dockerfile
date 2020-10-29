FROM nginx:1.18.0-alpine

COPY start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    apk update && \
    apk add --no-cache bash && \
    apk add --no-cache vim && \
    apk add --no-cache apache2-utils && \
    mkdir /etc/nginx/certs && \
    mkdir /etc/nginx/certs/privkey && \
    mkdir /etc/nginx/certs/chain && \
    mkdir /etc/nginx/certs/cert && \
    mkdir /etc/nginx/pwd && \
    chmod +x /opt/start.sh
    
ENV ADMIN_USER_ID=administrator
ENV ADMIN_USER_PWD=admin123

EXPOSE 80 443

CMD ["/opt/start.sh"]