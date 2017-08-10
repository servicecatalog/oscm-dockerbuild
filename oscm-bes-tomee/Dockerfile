FROM oscm-tomee

#ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt
#ENV DB_HOST_BES=oscm-db DB_PORT_BES=5432 DB_NAME_BES=bss DB_USER_BES=bssuser DB_PWD_BES=bssuser
#ENV DB_TIMEOUT_BES=300 DB_WAIT_BES=60000 DB_RETRY_INTERVAL_BES=10 DB_TIMEOUT_MI=300 DB_WAIT_MI=60000 DB_RETRY_INTERVAL_MI=10
#ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser
#ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret
#
#RUN /opt/glassfish4/glassfish/bin/asadmin create-domain --portbase 8400 --nopassword=true master-indexer-domain && \
#    /opt/glassfish4/glassfish/bin/asadmin create-domain --portbase 8000 --nopassword=true bes-domain && \
#	mkdir /opt/properties && \
#	mkdir /opt/certs && \
#	mkdir /opt/key
#
#COPY keystore.jks_bes /opt/glassfish4/glassfish/domains/bes-domain/config/keystore.jks
#COPY cacerts.jks_bes /opt/glassfish4/glassfish/domains/bes-domain/config/cacerts.jks
#
#COPY keystore.jks_mi /opt/glassfish4/glassfish/domains/master-indexer-domain/config/keystore.jks
#COPY cacerts.jks_mi /opt/glassfish4/glassfish/domains/master-indexer-domain/config/cacerts.jks

RUN mkdir /opt/apache-tomee-plume-7.0.3/apps

COPY oscm.ear /opt/apache-tomee-plume-7.0.3/apps
COPY oscm-portal.war /opt/apache-tomee-plume-7.0.3/webapps

#COPY templates/*.template /opt/templates/
#
#COPY resources/login.conf /opt/glassfish4/glassfish/domains/bes-domain/config/
#COPY resources/accesscontrol.properties resources/passwd /opt/glassfish4/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/etc/
#COPY resources/config.properties /opt/glassfish4/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props/
#COPY resources/accesscontrol.properties resources/passwd /opt/glassfish4/glassfish/domains/bes-domain/imq/instances/imqbroker/etc/
#COPY resources/config.properties /opt/glassfish4/glassfish/domains/bes-domain/imq/instances/imqbroker/props/
#
COPY oscm-security.jar /opt/apache-tomee-plume-7.0.3/lib/

COPY resources/jaas.config /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/server.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/setenv.sh /opt/apache-tomee-plume-7.0.3/bin/
COPY resources/system.properties /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomee.xml /opt/apache-tomee-plume-7.0.3/conf/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
