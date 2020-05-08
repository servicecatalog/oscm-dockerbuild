FROM nginx:1.18.0-alpine

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    apk update && \
    apk add bash && \
    apk add vim
    
COPY resources/nginx.conf /etc/nginx/conf.d/


EXPOSE 80 443

