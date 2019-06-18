FROM oscm-centos-based

COPY ssl.crt /opt/ssl.crt
COPY ssl.key /opt/ssl.key
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors

COPY oscm-identity.jar main.jar

ENTRYPOINT ["java", "-Dhttp.proxyHost=$PROXY_HTTP_HOST", "-Dhttp.proxyPort=$PROXY_HTTP_PORT", "-Dhttps.proxyHost=$PROXY_HTTPS_HOST", "-Dhttps.proxyPort=$PROXY_HTTPS_PORT", "-Djava.security.egd=file:/dev/./urandom", "-DJAVA_OPTS==-agentlib:jdwp=transport=dt_socket,address=$JPDA_ADDRESS,server=y,suspend=n" "-jar", "/main.jar"]

