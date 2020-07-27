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
echo "${DB_HOST_APP}:${DB_PORT_APP}:${DB_NAME_APP}:${DB_USER_APP}:${DB_PWD_APP}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_USER_APP} -l ${DB_NAME_APP} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
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

# Add oscm-core to NOPROXY
if [ -n "$PROXY_NOPROXY" ]; then
    export PROXY_NOPROXY="${PROXY_NOPROXY},oscm-core"
else
    export PROXY_NOPROXY="oscm-core"
fi

# Add Keystone host to NOPROXY
if [ -n "$OS_KEYSTONE_URL" ]; then
    KEYSTONE_HOST=$(echo $OS_KEYSTONE_URL | cut -d'/' -f3 | cut -d':' -f1)
    export PROXY_NOPROXY="${PROXY_NOPROXY},$KEYSTONE_HOST"
fi

/usr/bin/envsubst '$DB_HOST_APP $DB_PORT_APP $DB_NAME_APP $DB_USER_APP $DB_PWD_APP $SMTP_HOST $SMTP_PORT $SMTP_AUTH $SMTP_USER $SMTP_PWD $SMTP_FROM $SMTP_TLS $CONTAINER_CALLBACK_THREADS $CONTAINER_MAX_SIZE' < /opt/apache-tomee/conf/tomee_template.xml > /opt/apache-tomee/conf/tomee.xml

# Fix NONPROXY variable format for Java
export PROXY_NOPROXY=$(echo $PROXY_NOPROXY | sed -e 's/,/|/g')
/usr/bin/envsubst '$PROXY_HTTP_HOST $PROXY_HTTP_PORT $PROXY_HTTPS_HOST $PROXY_HTTPS_PORT $PROXY_NOPROXY' < /opt/apache-tomee/conf/catalina_template.properties > /opt/apache-tomee/conf/catalina.properties

# Fix NONPROXY variable format for Java again
export PROXY_NOPROXY=$(echo $PROXY_NOPROXY | sed -e 's/|/\\|/g')
/usr/bin/envsubst '$PROXY_ENABLED $PROXY_HTTP_HOST $PROXY_HTTP_PORT $PROXY_HTTPS_HOST $PROXY_HTTPS_PORT $PROXY_NOPROXY' < /opt/apache-tomee/bin/catalina_template.sh > /opt/apache-tomee/bin/catalina.sh

# Change entropy source of Java to non-blocking
sed -i 's|^securerandom.source=file:\/dev\/random|securerandom.source=file:/dev/./urandom|g' /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/java.security

# Call custom installation tasks
if [ -f /opt/scripts/start.sh ]; then
        /opt/scripts/start.sh &
fi

# Set proxy variables for curl, yum e.a.
if [ "$PROXY_ENABLED" = "true" ]
then
  export http_proxy=http://$PROXY_HTTP_HOST:$PROXY_HTTP_PORT
  export https_proxy=http://$PROXY_HTTPS_HOST:$PROXY_HTTPS_PORT
fi

# Start domains
if [ ${TOMEE_DEBUG} ]; then
	/opt/apache-tomee/bin/catalina.sh jpda run
else
	/opt/apache-tomee/bin/catalina.sh run
fi
