#!/bin/bash

# Copy external SSL key and cert if available
# otherwise create our own
if [ $(find temp-files -type f -name "*.crt" | wc -l) == "1" ] && [ $(find temp-files -type f -name "*.key" | wc -l) == "1" ]; then
    find /proxy-ssl -type f -name "*.crt" -exec cp -f {} /etc/proxy-ssl/tls.crt \;
    find /proxy-ssl -type f -name "*.key" -exec cp -f {} /etc/proxy-ssl/tls.key \;
else
    /usr/bin/openssl req -new -newkey rsa:4096 -sha256 -days 3650 -nodes -x509 -subj "/CN=oscm" -keyout /etc/proxy-ssl/tls.key -out /etc/proxy-ssl/tls.crt
fi
chown root: /etc/proxy-ssl/tls.crt
chmod 644 /etc/proxy-ssl/tls.crt
chown root: /etc/proxy-ssl/tls.key
chmod 640 /etc/proxy-ssl/tls.key

/usr/bin/envsubst < /opt/templates/oscm.conf.template > /etc/nginx/vhosts.d/oscm.conf

/usr/sbin/nginx
