#!/bin/bash
# Create and configure data directory
if [ ! -d /var/lib/postgresql/data ]; then
    mkdir -p /var/lib/postgresql/data
fi
chown -R postgres: /var/lib/postgresql
chmod 700 /var/lib/postgresql/data

# Create temporary superuser password file
echo ${DB_SUPERPWD} > /tmp/pw

# Initialize database
su - postgres -c 'initdb -U postgres -D /var/lib/postgresql/data --pwfile=/tmp/pw > /tmp/postgres-initdb.log 2>&1'

# If initdb failed because a database already exists, only set the
# superuser password again, in case it changed
if [ $? -ne 0 ]; then
    su - postgres -c 'postgres -D /var/lib/postgresql/data' &
    until su - postgres -c 'psql -U postgres -l' >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
    su - postgres -c "psql -U postgres -c \"ALTER USER postgres WITH PASSWORD '${DB_SUPERPWD}';\""
    su - postgres -c 'pg_ctl -D /var/lib/postgresql/data stop'
fi

# Remove temporary superuser password file
rm -f /tmp/pw

# Alter configuration for Catalog Manager
su - postgres -c 'sed -e "s|#*max_prepared_transactions.*|max_prepared_transactions = 50|g" -e "s|#*max_connections.*|max_connections = 250|g" -e "s|#*listen_addresses =.*|listen_addresses = '"'"'*'"'"'|g" /usr/share/pgsql/postgresql.conf.sample > /var/lib/postgresql/data/postgresql.conf'
su - postgres -c 'echo "host all all all md5" >> /var/lib/postgresql/data/pg_hba.conf'

# Start PostgreSQL
su - postgres -c 'postgres -D /var/lib/postgresql/data'
