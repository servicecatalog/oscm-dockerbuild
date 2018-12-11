#!/bin/bash
if [ ! -z ${HOST_FQDN} ]; then
    sed -i "s|^#base_url=http://127.0.0.1:8080|base_url=https://${HOST_FQDN}:8681|g" /srv/tomcat/webapps/birt/WEB-INF/viewer.properties
fi

# Copy SSL private key and certificate, generate Keystore and copy to Tomcat config
find /import/ssl/privkey -type f -exec cp -f {} /opt/ssl.key \;
find /import/ssl/cert -type f -exec cp -f {} /opt/ssl.crt \;
find /import/ssl/chain -type f -exec cp -f {} /opt/ssl.chain \;
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
find /import/certs -type f -exec cp {} /usr/share/pki/ca-trust-source/anchors \;
for certfile in /usr/share/pki/ca-trust-source/anchors/*; do
    trust anchor --store $certfile
done
find /usr/pki/trust -type f -name "*.p11-kit" -exec sed -i 's|^certificate-category: other-entry$|certificate-category: authority|g' {} \;
/usr/sbin/update-ca-certificates

# Change entropy source of Java to non-blocking
sed -i 's|^securerandom.source=file:\/dev\/random|securerandom.source=file:/dev/./urandom|g' /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/java.security

# Check ownership of Tomcat log dir and fix if necessary
if [ ! $(stat -c %U /var/log/tomcat) = "tomcat" ]; then
    chown tomcat /var/log/tomcat
fi

su - tomcat -c 'source /etc/tomcat/tomcat.conf ; source /etc/sysconfig/tomcat ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/lib/tomcat/server start'
