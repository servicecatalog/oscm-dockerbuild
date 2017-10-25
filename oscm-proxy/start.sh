#!/bin/bash

# Copy SSL private key and certificate, generate Keystore and copy to Tomcat config
find /import/ssl/privkey -type f -exec cp -f {} /opt/ssl.key \;
find /import/ssl/cert -type f -exec cp -f {} /opt/ssl.crt \;
find /import/ssl/chain -type f -exec cp -f {} /opt/ssl.chain \;
if [ -f /opt/ssl.chain ]; then
    cat /opt/ssl.crt /opt/ssl.chain > /etc/nginx/ssl.crt
else
    cp /opt/ssl.crt /etc/nginx/ssl.crt
fi
cp /opt/ssl.key /etc/nginx/ssl.key

/usr/bin/envsubst '$SERVERNAME $CORE_NAME $CORE_PORT $BRANDING_NAME $BRANDING_PORT $BIRT_NAME $BIRT_PORT $APP_NAME $APP_PORT' < /opt/templates/oscm.conf.template > /etc/nginx/vhosts.d/oscm.conf

/usr/sbin/nginx
