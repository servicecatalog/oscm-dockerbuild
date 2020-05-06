FROM nginx:1.18.0-alpine

COPY resources/nginx.conf /etc/nginx/

EXPOSE 80 443

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
