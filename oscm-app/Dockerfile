FROM oscm-gf

RUN mkdir /opt/app/apache-tomee-plume-7.0.3/apps

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt IDP_WSDL_URL=dummy IDP_TARGET_NAMESPACE=dummy
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV DB_TIMEOUT_APP=300 DB_WAIT_APP=60000 DB_RETRY_INTERVAL_APP=10
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret

COPY oscm-app.ear /opt/app/apache-tomee-plume-7.0.3/apps/

COPY templates/*.template /opt/templates/

COPY resources/server.xml /opt/app/apache-tomee-plume-7.0.3/conf/
COPY resources/setenv.sh /opt/app/apache-tomee-plume-7.0.3/bin/
COPY resources/system.properties /opt/app/apache-tomee-plume-7.0.3/conf/
COPY resources/tomcat-users.xml /opt/app/apache-tomee-plume-7.0.3/conf/
COPY resources/tomee.xml /opt/app/apache-tomee-plume-7.0.3/conf/

COPY start.sh /opt/app/
RUN chmod +x /opt/app/start.sh

CMD ["/opt/app/start.sh"]
