FROM oscm-gf

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt IDP_WSDL_URL=dummy IDP_TARGET_NAMESPACE=dummy
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV DB_TIMEOUT_APP=300 DB_WAIT_APP=60000 DB_RETRY_INTERVAL_APP=10
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret SMTP_TLS_ENABLE=false

RUN /opt/glassfish4/glassfish/bin/asadmin create-domain --portbase 8800 --nopassword=true app-domain && \
	mkdir /opt/properties && \
	mkdir /opt/sso && \
	mkdir /opt/certs && \
	mkdir /opt/key

COPY cacerts.jks_app /opt/glassfish4/glassfish/domains/app-domain/config/cacerts.jks
COPY keystore.jks_app /opt/glassfish4/glassfish/domains/app-domain/config/keystore.jks
	
COPY oscm-app.ear oscm-app-aws.ear oscm-app-openstack.ear /opt/glassfish4/glassfish/domains/app-domain/autodeploy/

COPY templates/*.template /opt/templates/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
