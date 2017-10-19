#!/bin/bash
if [ ! -z ${BASE_URL} ]; then
    sed -i "s|^#base_url=http://127.0.0.1:8080|base_url=${BASE_URL}|g" /srv/tomcat/webapps/birt/WEB-INF/viewer.properties
fi

# Copy SSL private key and certificate, generate Keystore and copy to Tomcat config
find /import/ssl/privkey -type f -exec cp -f {} /opt/ssl.key
find /import/ssl/cert -type f -exec cp -f {} /opt/ssl.crt
find /import/ssl/chain -type f -exec cp -f {} /opt/ssl.chain
if [ -f /opt/ssl.chain ]; then
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /etc/tomcat/ssl.p12 \
        -CAfile /opt/ssl.chain \
        -chain \
        -passout pass:changeit
else
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /etc/tomcat/ssl.p12 \
        -passout pass:changeit
fi

# Import SSL certificates into truststore
find /import/certs -type f -exec cp {} /usr/share/pki/trust/anchors \;
/usr/sbin/update-ca-certificates

# Change entropy source of Java to non-blocking
sed -i 's|^securerandom.source=file:\/dev\/random|securerandom.source=file:/dev/./urandom|g' /usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/jre/lib/security/java.security

su - tomcat -c 'source /etc/tomcat/tomcat.conf ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat-sysd start'
