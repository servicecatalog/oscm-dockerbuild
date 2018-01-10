FROM oscm-nginx

ENV SOURCE=LOCAL HELP_DIR=/import/oscm-portal-help

COPY start.sh /opt/start.sh
COPY resources/help.conf /etc/nginx/vhosts.d/
COPY oscm-portal-help.war /opt/oscm-portal-help.war
COPY ssl.crt /opt/ssl.crt
COPY ssl.key /opt/ssl.key
COPY ssl.crt /usr/share/pki/trust/anchors

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    chmod +x /opt/start.sh && \
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi

EXPOSE 80 443

CMD ["/opt/start.sh"]
