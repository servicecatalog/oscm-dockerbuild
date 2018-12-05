FROM oscm-sles-based

ENV DB_SUPERPWD=postgres

COPY start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y postgresql-server && \
    yum clean all && \
    chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
