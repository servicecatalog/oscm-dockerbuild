#!/bin/bash
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
find /etc/pki/trust -type f -name "*.p11-kit" -exec sed -i 's|^certificate-category: other-entry$|certificate-category: authority|g' {} \;
/usr/sbin/update-ca-certificates

# Get branding archives from local directory
if [ ${SOURCE} == "LOCAL" ]; then
    /usr/bin/cp ${BRANDING_DIR}/*.tar.gz /tmp/work
fi

# Attention: google-cloud-sdk broken; python-Jinja2 not available for SLE_12_SP1
# Get branding archives from bucket
# if [ ${SOURCE} == "BUCKET" ]; then
#     /usr/bin/gcloud auth activate-service-account --key-file ${GS_SERVICE_ACCOUNT_KEY_FILE}
#     /usr/bin/gsutil cp gs://${GS_BUCKET}/*.tar.gz /tmp/work
# fi

for file in /tmp/work/*.tar.gz
do
    /bin/tar -zxf $file -C /srv/www/htdocs
done
/usr/bin/chown -R nginx: /srv/www/htdocs
/usr/bin/rm -r /tmp/work

/usr/sbin/nginx
