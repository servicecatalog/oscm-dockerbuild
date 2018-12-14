FROM oscm-centos-based

ENV DB_SUPERPWD=postgres

COPY start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum makecache fast

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum install -y install postgresql96 postgresql96-server && \
    yum clean all && \
    chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
