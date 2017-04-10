#!/bin/bash
if [ ! -z ${BASE_URL} ]; then
    sed -i "s|^#base_url=http://127.0.0.1:8080|base_url=${BASE_URL}|g" /usr/local/tomcat/webapps/birt/WEB-INF/viewer.properties
fi

/usr/local/tomcat/bin/catalina.sh run

