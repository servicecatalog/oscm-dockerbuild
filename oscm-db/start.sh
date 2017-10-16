#!/bin/bash
# Create and configure data directory
if [ ! -d /var/lib/postgresql/data ]; then
    mkdir -p /var/lib/postgresql/data
fi
chown -R postgres: /var/lib/postgresql
chmod 700 /var/lib/postgresql/data
sed -i 's|POSTGRES_DATADIR="~postgres/data"|POSTGRES_DATADIR="/var/lib/postgresql/data"|g' /etc/sysconfig/postgresql

# Create temporary superuser password file
echo ${DB_SUPERPWD} > /tmp/pw

# Initialize database
su - postgres -c 'initdb -U postgres -D /var/lib/postgresql/data --pwfile=/tmp/pw > /tmp/postgres-initdb.log 2>&1'

# Remove temporary superuser password file
rm -f /tmp/pw

# Alter configuration for Catalog Manager
su - postgres -c 'sed -e "s|#*max_prepared_transactions.*|max_prepared_transactions = 50|g" -e "s|#*max_connections.*|max_connections = 250|g" -e "s|#*listen_addresses =.*|listen_addresses = '"'"'*'"'"'|g" /usr/share/postgresql94/postgresql.conf.sample > /var/lib/postgresql/data/postgresql.conf'
su - postgres -c 'echo "host all all all md5" >> /var/lib/postgresql/data/pg_hba.conf'

# Start PostgreSQL
su - postgres -c 'postgres -D /var/lib/postgresql/data'
