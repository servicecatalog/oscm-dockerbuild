FROM oscm-sles-based

COPY start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper in -y postgresql94-server && \
    chmod +x /opt/start.sh && \
    SUSEConnect -d

CMD ["/opt/start.sh"]
