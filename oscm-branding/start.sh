#!/bin/bash

for file in ${BRANDING_DIR}/*.tar.gz
do
    tar -zxf $file -C /usr/share/nginx/html
done

nginx -g 'daemon off;'
