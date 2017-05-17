FROM oscm-gf

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt
ENV DB_HOST_BES=oscm-db DB_PORT_BES=5432 DB_NAME_BES=bss DB_USER_BES=bssuser DB_PWD_BES=bssuser
ENV DB_HOST_JMS=$DB_HOST_BES DB_PORT_JMS=$DB_PORT_BES DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret

RUN /opt/glassfish4/glassfish/bin/asadmin create-domain --portbase 8400 --nopassword=true --savemasterpassword=true master-indexer-domain && \
    /opt/glassfish4/glassfish/bin/asadmin create-domain --portbase 8000 --nopassword=true --savemasterpassword=true bes-domain && \
	mkdir /opt/properties && \
	mkdir /opt/certs && \
	mkdir /opt/key
	
COPY keystore.jks_bes /opt/glassfish4/glassfish/domains/bes-domain/config/keystore.jks
COPY cacerts.jks_bes /opt/glassfish4/glassfish/domains/bes-domain/config/cacerts.jks

COPY keystore.jks_mi /opt/glassfish4/glassfish/domains/master-indexer-domain/config/keystore.jks
COPY cacerts.jks_mi /opt/glassfish4/glassfish/domains/master-indexer-domain/config/cacerts.jks

COPY oscm.ear oscm-sso.ear /opt/ear/
COPY oscm-search.ear /opt/glassfish4/glassfish/domains/master-indexer-domain/autodeploy/
COPY oscm-portal.war oscm-portal-help.war /opt/glassfish4/glassfish/domains/bes-domain/autodeploy/

COPY sqlscripts/*.sql /opt/sqlscripts/
COPY templates/*.template /opt/templates/
COPY resources/imq/* /opt/glassfish4/glassfish/domains/bes-domain/imq/
COPY resources/imq/* /opt/glassfish4/glassfish/domains/master-indexer-domain/imq/
COPY oscm-devruntime.jar /opt/

COPY oscm-security.jar /opt/glassfish4/glassfish/domains/bes-domain/lib/
COPY oscm-common.jar oscm-extsvc-internal.jar oscm-extsvc-platform.jar oscm-server-common.jar /opt/lib

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
