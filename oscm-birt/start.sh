#!/bin/bash
#if [ ! -z ${BASE_URL} ]; then
#    sed -i "s|^#base_url=http://127.0.0.1:8080|base_url=${BASE_URL}|g" /srv/tomcat/webapps/birt/WEB-INF/viewer.properties
#fi
#
#cp /certs/*.crt /usr/share/pki/trust/anchors
#/usr/sbin/update-ca-certificates
#
#su - tomcat -c 'source /etc/tomcat/tomcat.conf ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat-sysd start'
/opt/tomcat-9/apache-tomcat-9.0.1/bin/catalina.sh run