#!/bin/bash

# Wait for database
/usr/bin/touch /root/.pgpass
/usr/bin/chmod 600 /root/.pgpass
echo "${DB_HOST_BES}:${DB_PORT_BES}:${DB_NAME_BES}:${DB_USER_BES}:${DB_PWD_BES}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_BES} -p ${DB_PORT_BES} -U ${DB_USER_BES} -l ${DB_NAME_BES} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
/usr/bin/rm -f /root/.pgpass

# Start domains
/opt/app/apache-tomee-plume-7.0.3/bin/catalina.sh run &
