#!/bin/bash

# Copy external SSL key and cert if available
# otherwise create our own
if [ $(find /import -type f -name "*.crt" | wc -l) == "1" ] && [ $(find /import -type f -name "*.key" | wc -l) == "1" ]; then
    find /import -type f -name "*.crt" -exec cp -f {} /etc/proxy-ssl/tls.crt \;
    find /import -type f -name "*.key" -exec cp -f {} /etc/proxy-ssl/tls.key \;
else
    /usr/bin/openssl req -new -newkey rsa:4096 -sha256 -days 3650 -nodes -x509 -subj "/CN=oscm" -keyout /etc/proxy-ssl/tls.key -out /etc/proxy-ssl/tls.crt
fi
chown root: /etc/proxy-ssl/tls.crt
chmod 644 /etc/proxy-ssl/tls.crt
chown root: /etc/proxy-ssl/tls.key
chmod 640 /etc/proxy-ssl/tls.key

/usr/bin/envsubst '$SERVERNAME $CORE_NAME $CORE_PORT $BRANDING_NAME $BRANDING_PORT $BIRT_NAME $BIRT_PORT $APP_NAME $APP_PORT' < /opt/templates/oscm.conf.template > /etc/nginx/vhosts.d/oscm.conf

/usr/sbin/nginx
