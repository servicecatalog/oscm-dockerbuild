#!/bin/bash
if [ ! -z ${HOST_FQDN} ]; then
    sed -i "s|^#base_url=http://127.0.0.1:8080|base_url=http://${HOST_FQDN}:8080|g" /srv/tomcat/webapps/birt/WEB-INF/viewer.properties
fi

cp /certs/*.crt /usr/share/pki/trust/anchors
/usr/sbin/update-ca-certificates

su - tomcat -c 'source /etc/tomcat/tomcat.conf ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat-sysd start'
