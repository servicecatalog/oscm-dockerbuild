FROM oscm-gf

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt IDP_WSDL_URL=dummy IDP_TARGET_NAMESPACE=dummy
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV DB_TIMEOUT_APP=300 DB_WAIT_APP=60000 DB_RETRY_INTERVAL_APP=10
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper -n in gettext-runtime vim postgresql94 java-1_8_0-openjdk java-1_8_0-openjdk-devel && \
    zypper clean && \
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi && \
    wget http://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/7.0.3/apache-tomee-7.0.3-plume.zip -O /tmp/apache-tomee-7.0.3-plume.zip && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-157.jar -O /usr/lib64/jvm/java-1.8.0-openjdk/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib64/jvm/java-1.8.0-openjdk/jre/lib/security/java.security && \
    unzip /tmp/apache-tomee-7.0.3-plume.zip -d /opt/ && \
    rm /tmp/apache-tomee-7.0.3-plume.zip

COPY oscm-app.ear oscm-app-aws.ear oscm-app-openstack.ear /opt/apache-tomee-plume-7.0.3/apps/

COPY resources/server.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/system.properties /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomee.xml /opt/apache-tomee-plume-7.0.3/conf/

COPY templates/*.template /opt/templates/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
