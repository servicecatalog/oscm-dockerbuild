FROM nginx:1.18.0-alpine

RUN apt-get update
RUN apt-get install vim
COPY resources/nginx.conf /etc/nginx/

EXPOSE 80 443

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
