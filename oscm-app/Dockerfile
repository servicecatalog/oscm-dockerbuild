FROM oscm-gf

RUN mkdir /opt/apache-tomee-plume-7.0.3/apps && \
 mkdir /opt/apache-tomee-plume-7.0.3/controllers && \
 mkdir /opt/properties && \
 mkdir /opt/sso && \
 mkdir /opt/certs && \
 mkdir /opt/key

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt IDP_WSDL_URL=dummy IDP_TARGET_NAMESPACE=dummy
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV DB_TIMEOUT_APP=300 DB_WAIT_APP=60000 DB_RETRY_INTERVAL_APP=10
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret SMTP_TLS_ENABLE=false

COPY resources/server.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/system.properties /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomee.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/key /opt/apache-tomee-plume-7.0.3/bin/

COPY oscm-app.ear /opt/apache-tomee-plume-7.0.3/apps/
COPY oscm-app-aws.ear oscm-app-openstack.ear /opt/apache-tomee-plume-7.0.3/controllers/

COPY postgresql-9.4-1206-jdbc42.jar /opt/apache-tomee-plume-7.0.3/lib/postgresql-9.4-1206-jdbc42.jar
COPY oscm-app-extsvc-2-0.jar /opt/apache-tomee-plume-7.0.3/lib/oscm-app-extsvc-2-0.jar

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
