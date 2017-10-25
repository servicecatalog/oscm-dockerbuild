FROM oscm-sles-based

ENV DB_SUPERPWD=postgres

COPY start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper in -y postgresql94-server && \
    zypper clean && \
    chmod +x /opt/start.sh && \
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi

CMD ["/opt/start.sh"]
