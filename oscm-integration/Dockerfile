FROM oscm-gf

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt
ENV DB_HOST_BES=oscm-db DB_PORT_BES=5432 DB_NAME_BES=bss DB_USER_BES=bssuser DB_PWD_BES=bssuser
ENV DB_TIMEOUT_BES=300 DB_WAIT_BES=60000 DB_RETRY_INTERVAL_BES=10 DB_TIMEOUT_MI=300 DB_WAIT_MI=60000 DB_RETRY_INTERVAL_MI=10
ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret

RUN /opt/glassfish4/glassfish/bin/asadmin create-domain --portbase 8000 --nopassword=true example-domain && \
	mkdir /opt/properties && \
	mkdir /opt/certs && \
	mkdir /opt/key
	
COPY keystore.jks_example /opt/glassfish4/glassfish/domains/example-domain/config/keystore.jks
COPY cacerts.jks_example /opt/glassfish4/glassfish/domains/example-domain/config/cacerts.jks

COPY templates/*.template /opt/templates/

COPY resources/login.conf /opt/glassfish4/glassfish/domains/example-domain/config/
COPY resources/accesscontrol.properties resources/passwd /opt/glassfish4/glassfish/domains/example-domain/imq/instances/imqbroker/etc/
COPY resources/config.properties /opt/glassfish4/glassfish/domains/example-domain/imq/instances/imqbroker/props/

COPY oscm-security.jar /opt/glassfish4/glassfish/domains/example-domain/lib/

COPY example-service.war oscm-integrationtests-mockproduct.war mock-psp-service.war oscm-integrationtests-saml2-sts.war oscm-psp-heidelpay.war oscm-parameter-configurator.war oscm-file-adapter.ear oscm-file-billing.war /opt/glassfish4/glassfish/domains/example-domain/applications/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
