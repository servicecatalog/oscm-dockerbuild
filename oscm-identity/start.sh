#!/bin/bash
HTTP_PROXY_HOST=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
HTTP_PROXY_PORT=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
HTTPS_PROXY_HOST=$(echo $https_proxy | cut -d'/' -f3 | cut -d':' -f1)
HTTPS_PROXY_PORT=$(echo $https_proxy | cut -d'/' -f3 | cut -d':' -f2)

if [ ${TOMEE_DEBUG} ]; then
	java -Dhttp.proxyHost=$PROXY_HTTP_HOST -Dhttp.proxyPort=$PROXY_HTTP_PORT -Dhttps.proxyHost=$PROXY_HTTPS_HOST -Dhttps.proxyPort=$PROXY_HTTPS_PORT -Djava.security.egd=file:/dev/./urandom -jar /opt/identity/main.jar -Dagentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=9000 -Dlogging.level.org.oscm.identity=DEBUG
else
	java -Dhttp.proxyHost=$PROXY_HTTP_HOST -Dhttp.proxyPort=$PROXY_HTTP_PORT -Dhttps.proxyHost=$PROXY_HTTPS_HOST -Dhttps.proxyPort=$PROXY_HTTPS_PORT -Djava.security.egd=file:/dev/./urandom -jar /opt/identity/main.jar
fi
