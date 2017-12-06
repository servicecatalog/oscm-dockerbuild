FROM oscm-tomee

RUN mkdir /opt/apache-tomee/apps
RUN mkdir -p /templates/WEB-INF

ENV AUTH_MODE=INTERNAL KEY_SECRET=secretsecret1234 DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt
ENV DB_HOST_CORE=oscm-db DB_PORT_CORE=5432 DB_NAME_CORE=bss DB_USER_CORE=bssuser DB_PWD_CORE=bssuser
ENV DB_TIMEOUT_CORE=300 DB_WAIT_CORE=60000 DB_RETRY_INTERVAL_CORE=10 DB_TIMEOUT_MI=300 DB_WAIT_MI=60000 DB_RETRY_INTERVAL_MI=10
ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret SMTP_TLS_ENABLE=false

COPY resources/web.xml /templates/WEB-INF
COPY oscm.ear /opt/apache-tomee/apps
# COPY oscm-portal-help.war /opt/apache-tomee/webapps

COPY oscm-security.jar /opt/apache-tomee/lib/
COPY oscm-common.jar /opt/apache-tomee/lib/
COPY oscm-rest-api-common.jar /opt/apache-tomee/lib/
COPY oscm-extsvc-internal.jar /opt/apache-tomee/lib/
COPY oscm-saml2-api.jar /opt/apache-tomee/lib/
COPY commons-validator.jar /opt/apache-tomee/lib/

COPY postgresql.jar /opt/apache-tomee/lib/postgresql.jar
COPY log4j.jar /opt/apache-tomee/lib/log4j.jar

COPY resources/jaas.config /opt/apache-tomee/conf/
COPY resources/server.xml /opt/apache-tomee/conf/
COPY resources/setenv.sh /opt/apache-tomee/bin/
COPY resources/system.properties /opt/apache-tomee/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee/conf/
COPY resources/tomee_template.xml /opt/apache-tomee/conf/
COPY resources/key /opt/apache-tomee/bin/
COPY resources/web.xml /templates/WEB-INF
COPY resources/catalina.properties /opt/apache-tomee/conf/catalina.properties
COPY resources/context.xml /opt/apache-tomee/conf/context.xml

COPY ssl.key ssl.crt /opt/
COPY ssl.crt /import/certs/
COPY ssl.crt /usr/share/pki/trust/anchors

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
