#!/bin/bash

/usr/bin/touch /root/.pgpass
/usr/bin/chmod 600 /root/.pgpass
echo "${DB_HOST_APP}:${DB_PORT_APP}:${DB_NAME_APP}:${DB_USER_APP}:${DB_PWD_APP}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_USER_APP} -l ${DB_NAME_APP} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
/usr/bin/rm -f /root/.pgpass

# Copy SSL private key and certificate, generate Keystore and copy to Tomcat config
find /import/ssl/privkey -type f -exec cp -f {} /opt/ssl.key
find /import/ssl/cert -type f -exec cp -f {} /opt/ssl.crt
find /import/ssl/chain -type f -exec cp -f {} /opt/ssl.chain
if [ -f /opt/ssl.chain ]; then
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /opt/apache-tomee-plume-7.0.3/conf/ssl.p12 \
        -CAfile /opt/ssl.chain \
        -chain \
        -passout pass:changeit
else
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /opt/apache-tomee-plume-7.0.3/conf/ssl.p12 \
        -passout pass:changeit
fi

# Import SSL certificates into truststore
find /import/certs -type f -exec cp {} /usr/share/pki/trust/anchors \;
/usr/sbin/update-ca-certificates

/usr/bin/envsubst '$DB_HOST_APP $DB_PORT_APP $DB_NAME_APP $DB_USER_APP $DB_PWD_APP $SMTP_HOST $SMTP_PORT $SMTP_AUTH $SMTP_USER $SMTP_PWD $SMTP_FROM $SMTP_TLS_ENABLE' < /opt/apache-tomee-plume-7.0.3/conf/tomee_template.xml > /opt/apache-tomee-plume-7.0.3/conf/tomee.xml

# Change entropy source of Java to non-blocking
sed -i 's|^securerandom.source=file:\/dev\/random|securerandom.source=file:/dev/./urandom|g' /usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/jre/lib/security/java.security

# Start domains
if [ ${TOMEE_DEBUG} ]; then
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh jpda run
else
	/opt/apache-tomee-plume-7.0.3/bin/catalina.sh run
fi
