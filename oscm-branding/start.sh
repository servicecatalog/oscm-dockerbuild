#!/bin/bash

if [ ! -z ${BRANDING_DIR} ] && [ -f ${BRANDING_DIR} ]; then
    for file in ${BRANDING_DIR}/*.tar.gz
    do
        tar -zxf $file -C /usr/share/nginx/html
    done
fi

nginx -g 'daemon off;'
