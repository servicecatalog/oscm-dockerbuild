#!/bin/bash
 
/usr/bin/touch /root/.pgpass
/usr/bin/chmod 600 /root/.pgpass
echo "${DB_HOST_CORE}:${DB_PORT_CORE}:${DB_NAME_CORE}:${DB_USER_CORE}:${DB_PWD_CORE}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_CORE} -p ${DB_PORT_CORE} -U ${DB_USER_CORE} -l ${DB_NAME_CORE} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
/usr/bin/rm -f /root/.pgpass

cp /import/certs/*.crt /usr/share/pki/trust/anchors
/usr/sbin/update-ca-certificates

/usr/bin/envsubst '$DB_HOST_CORE $DB_PORT_CORE $DB_NAME_CORE $DB_USER_CORE $DB_PWD_CORE $SMTP_HOST $SMTP_PORT $SMTP_AUTH $SMTP_USER $SMTP_PWD $SMTP_FROM $SMTP_TLS_ENABLE' < /opt/apache-tomee-plume-7.0.3/conf/tomee_template.xml > /opt/apache-tomee-plume-7.0.3/conf/tomee.xml

# Change entropy source of Java to non-blocking
sed -i 's|^securerandom.source=file:\/dev\/random|securerandom.source=file:/dev/./urandom|g' /usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/jre/lib/security/java.security

# Start domains
if [ ${TOMEE_DEBUG} ]; then
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh jpda run
else
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh run
fi
