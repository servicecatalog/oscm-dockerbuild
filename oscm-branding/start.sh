#!/bin/bash

/usr/bin/gcloud auth activate-service-account --key-file ${SERVICE_ACCOUNT_KEY_FILE}
mkdir /tmp/work
/usr/bin/gsutil cp gs://${GS_BUCKET}/*.tar.gz /tmp/work
for file in /tmp/work/*.tar.gz
do
    tar -zxf $file -C /usr/share/nginx/html
done
chown -R root:root /usr/share/nginx/html
rm -r /tmp/work

nginx -g 'daemon off;'
