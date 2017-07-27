FROM oscm-sles-based

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper in -y postgresql94-server && \
    mkdir -p /var/lib/postgresql/data && \
    sed -i 's|POSTGRES_DATADIR="~postgres/data"|POSTGRES_DATADIR="/var/lib/postgresql/data"|g' /etc/sysconfig/postgresql && \
    chown -R postgres: /var/lib/postgresql && \
    chmod 700 /var/lib/postgresql/data

USER postgres

RUN postgres -c 'initdb -U postgres -D /var/lib/postgresql/data' && \
    sed -e 's|#*max_prepared_transactions.*|max_prepared_transactions = 50|g' \
        -e 's|#*max_connections.*|max_connections = 250|g' \
        /usr/share/postgresql94/postgresql.conf.sample > /var/lib/postgresql/data/postgresql.conf

ENTRYPOINT ["postgres", "-D", "/var/lib/postgresql/data"]
