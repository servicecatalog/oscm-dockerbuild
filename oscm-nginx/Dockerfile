FROM oscm-sles-based

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper addrepo http://download.opensuse.org/repositories/server:http/SLE_12/server:http.repo && \
    zypper --gpg-auto-import-keys refresh && \
    zypper install -y nginx vim && \
    zypper clean && \
    mkdir /etc/nginx/conf.d && \
    mkdir /etc/nginx/vhosts.d &&\
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY resources/nginx.conf /etc/nginx/
COPY resources/mime.types /etc/nginx/

EXPOSE 80 443

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
