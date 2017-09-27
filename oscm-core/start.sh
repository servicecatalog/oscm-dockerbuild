#!/bin/bash

# Wait for database
/usr/bin/touch /root/.pgpass
/usr/bin/chmod 600 /root/.pgpass
echo "${DB_HOST_CORE}:${DB_PORT_CORE}:${DB_NAME_CORE}:${DB_USER_CORE}:${DB_PWD_CORE}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_CORE} -p ${DB_PORT_CORE} -U ${DB_USER_CORE} -l ${DB_NAME_CORE} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
/usr/bin/rm -f /root/.pgpass


# Start domains
if [ ${TOMEE_DEBUG} ]; then
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh jpda run
else
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh run
fi
