#!/bin/bash

 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

# Create working directory
/usr/bin/mkdir /tmp/work

# Copy SSL private key and certificate, generate Keystore and copy to nginx config
find /import/ssl/privkey -type f -exec cp -f {} /opt/ssl.key \;
find /import/ssl/cert -type f -exec cp -f {} /opt/ssl.crt \;
find /import/ssl/chain -type f -exec cp -f {} /opt/ssl.chain \;
if [ -f /opt/ssl.chain ]; then
    cat /opt/ssl.crt /opt/ssl.chain > /etc/nginx/ssl.crt
else
    cp /opt/ssl.crt /etc/nginx/ssl.crt
fi
cp /opt/ssl.key /etc/nginx/ssl.key

# Import SSL certificates into truststore
find /import/certs -type f -exec cp {} /usr/share/pki/ca-trust-source/anchors \;
for certfile in /usr/share/pki/ca-trust-source/anchors/*; do
    trust anchor --store $certfile
done
find /etc/pki/ca-trust/source/anchors -type f -name "*.p11-kit" -exec sed -i 's|^certificate-category: other-entry$|certificate-category: authority|g' {} \;
/usr/bin/update-ca-trust

# Copies the script that uploads branding
cp /opt/compile_branding_packages.sh ${TARGET_PATH}/compile_branding_packages.sh
chmod +x ${TARGET_PATH}/compile_branding_packages.sh

find /import/brandings -type d -exec chmod o+rx {} \;
find /import/brandings -type f -exec chmod o+r {} \;

/usr/sbin/nginx
