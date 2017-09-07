FROM oscm-gf

RUN mkdir /opt/bes/apache-tomee-plume-7.0.3/apps

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt
ENV DB_HOST_BES=oscm-db DB_PORT_BES=5432 DB_NAME_BES=bss DB_USER_BES=bssuser DB_PWD_BES=bssuser
ENV DB_TIMEOUT_BES=300 DB_WAIT_BES=60000 DB_RETRY_INTERVAL_BES=10 DB_TIMEOUT_MI=300 DB_WAIT_MI=60000 DB_RETRY_INTERVAL_MI=10
ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret

COPY oscm.ear /opt/bes/apache-tomee-plume-7.0.3/apps/
COPY oscm-search.ear /opt/bes/apache-tomee-plume-7.0.3/apps/
COPY oscm-portal.war /opt/bes/apache-tomee-plume-7.0.3/webapps/

COPY oscm-security.jar /opt/bes/apache-tomee-plume-7.0.3/lib/

COPY resources/jaas.config /opt/bes/apache-tomee-plume-7.0.3/conf/
COPY resources/server.xml /opt/bes/apache-tomee-plume-7.0.3/conf/
COPY resources/setenv.sh /opt/bes/apache-tomee-plume-7.0.3/bin/
COPY resources/system.properties /opt/bes/apache-tomee-plume-7.0.3/conf/
COPY resources/tomcat-users.xml /opt/bes/apache-tomee-plume-7.0.3/conf/
COPY resources/tomee.xml /opt/bes/apache-tomee-plume-7.0.3/conf/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
