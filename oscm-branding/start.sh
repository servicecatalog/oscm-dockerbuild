#!/bin/bash

for file in ${BRANDING_DIR}/*.tar.gz
do
    tar -zxf $file -C /usr/share/nginx/html
done

chown -R root:root /usr/share/nginx/html

nginx -g 'daemon off;'
