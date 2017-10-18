#!/bin/bash
if [ ! -z ${BASE_URL} ]; then
    sed -i "s|^#base_url=http://127.0.0.1:8080|base_url=${BASE_URL}|g" /srv/tomcat/webapps/birt/WEB-INF/viewer.properties
fi

cp /import/certs/*.crt /usr/share/pki/trust/anchors
/usr/sbin/update-ca-certificates

# Change entropy source of Java to non-blocking
sed -i 's|^securerandom.source=file:\/dev\/random|securerandom.source=file:/dev/./urandom|g' /usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/jre/lib/security/java.security

su - tomcat -c 'source /etc/tomcat/tomcat.conf ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat-sysd start'
