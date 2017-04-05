#!/bin/bash

if [ ! -z $BRANDING_ARCHIVE ] && [ -f $BRANDING_ARCHIVE ]; then
    tar -zxf $BRANDING_ARCHIVE -C /usr/share/nginx/html
fi

nginx -g 'daemon off;'

