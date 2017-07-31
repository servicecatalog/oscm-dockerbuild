#!/bin/bash
# Create working directory
/usr/bin/mkdir /tmp/work

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
