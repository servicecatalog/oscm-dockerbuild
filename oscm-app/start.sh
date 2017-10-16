#!/bin/bash

/usr/bin/touch /root/.pgpass
/usr/bin/chmod 600 /root/.pgpass
echo "${DB_HOST_APP}:${DB_PORT_APP}:${DB_NAME_APP}:${DB_USER_APP}:${DB_PWD_APP}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_USER_APP} -l ${DB_NAME_APP} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
/usr/bin/rm -f /root/.pgpass

cp /import/certs/*.crt /usr/share/pki/trust/anchors
/usr/sbin/update-ca-certificates

/usr/bin/envsubst '$DB_HOST_APP $DB_PORT_APP $DB_NAME_APP $DB_USER_APP $DB_PWD_APP' < /opt/apache-tomee-plume-7.0.3/conf/tomee_template.xml > /opt/apache-tomee-plume-7.0.3/conf/tomee.xml

# Start domains
if [ ${TOMEE_DEBUG} ]; then
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh jpda run
else
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh run
fi
