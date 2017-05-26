#!/bin/bash
# Create working directory
/usr/bin/mkdir /tmp/work

# Get branding archives from local directory
if [ ${SOURCE} == "LOCAL" ]; then
    /usr/bin/cp BRANDING_DIR/*.tar.gz /tmp/work
fi

# Get branding archives from bucket
if [ ${SOURCE} == "BUCKET" ]; then
    /usr/bin/gcloud auth activate-service-account --key-file ${GS_SERVICE_ACCOUNT_KEY_FILE}
    /usr/bin/gsutil cp gs://${GS_BUCKET}/*.tar.gz /tmp/work
fi

for file in /tmp/work/*.tar.gz
do
    /usr/bin/tar -zxf $file -C /usr/share/nginx/html
done
/usr/bin/chown -R root:root /usr/share/nginx/html
/usr/bin/rm -r /tmp/work

/usr/sbin/nginx -g 'daemon off;'
