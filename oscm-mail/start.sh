#!/bin/bash

 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2021                                            *
 #*                                                                           *
 #* Creation Date: 17-03-2021                                                 *
 #*                                                                           *
 #*****************************************************************************

# Copy SSL private key and certificate
find /import/ssl/privkey -type f -exec cp -f {} /opt/ssl.key \;
find /import/ssl/cert -type f -exec cp -f {} /opt/ssl.crt \;
find /import/ssl/chain -type f -exec cp -f {} /opt/ssl.chain \;

if [ -f /opt/ssl.chain ]; then
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /opt/mail/ssl.p12 \
        -CAfile /opt/ssl.chain \
        -chain \
        -passout pass:changeit
else
    openssl pkcs12 -export \
        -in /opt/ssl.crt \
        -inkey /opt/ssl.key \
        -out /opt/mail/ssl.p12 \
        -passout pass:changeit

fi

# Import SSL certificates into truststore
find /import/certs -type f -exec cp {} /usr/share/pki/ca-trust-source/anchors \;
for certfile in /usr/share/pki/ca-trust-source/anchors/*; do
    trust anchor --store $certfile
done
find /import/ssl/cert -type f -exec cp {} /usr/share/pki/ca-trust-source/anchors \;
for certfile in /usr/share/pki/ca-trust-source/anchors/*; do
    trust anchor --store $certfile
done
find /etc/pki/ca-trust/source/anchors -type f -name "*.p11-kit" -exec sed -i 's|^certificate-category: other-entry$|certificate-category: authority|g' {} \;
/usr/bin/update-ca-trust

if [ ${TOMEE_DEBUG} ]; then
	java -Dhttp.proxyHost=$PROXY_HTTP_HOST -Dhttp.proxyPort=$PROXY_HTTP_PORT -Dhttps.proxyHost=$PROXY_HTTPS_HOST -Dhttps.proxyPort=$PROXY_HTTPS_PORT -Djava.security.egd=file:/dev/./urandom -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8500 -Dlogging.level.org.oscm.mail=DEBUG -jar /opt/mail/main.jar
else
	java -Dhttp.proxyHost=$PROXY_HTTP_HOST -Dhttp.proxyPort=$PROXY_HTTP_PORT -Dhttps.proxyHost=$PROXY_HTTPS_HOST -Dhttps.proxyPort=$PROXY_HTTPS_PORT -Djava.security.egd=file:/dev/./urandom  -jar /opt/mail/main.jar
fi
