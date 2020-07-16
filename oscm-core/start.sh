#!/bin/bash

 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

/usr/bin/touch /root/.pgpass
/usr/bin/chmod 600 /root/.pgpass
echo "${DB_HOST_CORE}:${DB_PORT_CORE}:${DB_NAME_CORE}:${DB_USER_CORE}:${DB_PWD_CORE}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_CORE} -p ${DB_PORT_CORE} -U ${DB_USER_CORE} -l ${DB_NAME_CORE} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
/usr/bin/rm -f /root/.pgpass

# Copy SSL private key and certificate, generate Keystore and copy to Tomcat config
find /import/ssl/privkey -type f -exec cp -f {} /opt/ssl.key \;
find /import/ssl/cert -type f -exec cp -f {} /opt/ssl.crt \;
find /import/ssl/chain -type f -exec cp -f {} /opt/ssl.chain \;
if [ -f /opt/ssl.chain ]; then
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /opt/apache-tomee/conf/ssl.p12 \
        -CAfile /opt/ssl.chain \
        -chain \
        -passout pass:changeit
else
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /opt/apache-tomee/conf/ssl.p12 \
        -passout pass:changeit
fi

# Import SSL certificates into truststore
find /import/certs -type f -exec cp {} /usr/share/pki/ca-trust-source/anchors \;
for certfile in /usr/share/pki/ca-trust-source/anchors/*; do
    trust anchor --store $certfile
done
find /etc/pki/ca-trust/source/anchors -type f -name "*.p11-kit" -exec sed -i 's|^certificate-category: other-entry$|certificate-category: authority|g' {} \;
/usr/bin/update-ca-trust

find /import/certs/sso -type f -exec cp {} /opt/trusted_certs \;
# Import trusted certificates into keystore
for trustedcert in /opt/trusted_certs/*; do
    echo "y" | keytool -importcert -file $trustedcert -keystore /opt/apache-tomee/conf/ssl.p12 -storepass changeit
done

/usr/bin/envsubst '$DB_HOST_CORE $DB_PORT_CORE $DB_NAME_CORE $DB_USER_CORE $DB_PWD_CORE $SMTP_HOST $SMTP_PORT $SMTP_AUTH $SMTP_USER $SMTP_PWD $SMTP_FROM $SMTP_TLS $CONTAINER_CALLBACK_THREADS $CONTAINER_MAX_SIZE' < /opt/apache-tomee/conf/tomee_template.xml > /opt/apache-tomee/conf/tomee.xml

# Change entropy source of Java to non-blocking
sed -i 's|^securerandom.source=file:\/dev\/random|securerandom.source=file:/dev/./urandom|g' /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/java.security

# Start domains
if [ ${TOMEE_DEBUG} ]; then
	/opt/apache-tomee/bin/catalina.sh jpda run
else
	/opt/apache-tomee/bin/catalina.sh run
fi
