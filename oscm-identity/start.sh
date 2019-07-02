#!/bin/bash
HTTP_PROXY_HOST=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
HTTP_PROXY_PORT=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
HTTPS_PROXY_HOST=$(echo $https_proxy | cut -d'/' -f3 | cut -d':' -f1)
HTTPS_PROXY_PORT=$(echo $https_proxy | cut -d'/' -f3 | cut -d':' -f2)

java -Dhttp.proxyHost=$PROXY_HTTP_HOST -Dhttp.proxyPort=$PROXY_HTTP_PORT -Dhttps.proxyHost=$PROXY_HTTPS_HOST -Dhttps.proxyPort=$PROXY_HTTPS_PORT -Djava.security.egd=file:/dev/./urandom -jar /opt/identity/main.jar