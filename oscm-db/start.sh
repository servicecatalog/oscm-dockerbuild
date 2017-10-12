#!/bin/bash
if [ ! -d /var/lib/postgresql/data ]; then
    mkdir -p /var/lib/postgresql/data
fi
sed -i 's|POSTGRES_DATADIR="~postgres/data"|POSTGRES_DATADIR="/var/lib/postgresql/data"|g' /etc/sysconfig/postgresql
chown -R postgres: /var/lib/postgresql
chmod 700 /var/lib/postgresql/data
echo "postgres" > /tmp/pw
su - postgres -c 'initdb -U postgres -D /var/lib/postgresql/data --pwfile=/tmp/pw > /tmp/postgres-initdb.log 2>&1'
rm -f /tmp/pw
su - postgres -c 'sed -e "s|#*max_prepared_transactions.*|max_prepared_transactions = 50|g" -e "s|#*max_connections.*|max_connections = 250|g" -e "s|#*listen_addresses =.*|listen_addresses = '"'"'*'"'"'|g" /usr/share/postgresql94/postgresql.conf.sample > /var/lib/postgresql/data/postgresql.conf'
su - postgres -c 'echo "host all all all md5" >> /var/lib/postgresql/data/pg_hba.conf'
su - postgres -c 'postgres -D /var/lib/postgresql/data'
if [ ${DB_SUPERPWD} != "postgres" ]; then
    su - postgres -c "ALTER USER postgres WITH SUPERUSER PASSWORD ${DB_SUPERPWD};"
fi
