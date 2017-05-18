FROM oscm-gf

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt IDP_WSDL_URL=dummy IDP_TARGET_NAMESPACE=dummy
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret

ENV APP_BASE_URL=http://localhost/oscm-app APP_ADMIN_MAIL_ADDRESS=address APP_TRUSTSTORE_BSS_ALIAS=bes-s1as
ENV APP_USER_KEY=1000 APP_USER_NAME=administrator APP_USER_PWD=admin123 BES_ID_SERVICE=id BES_ID_SERVICE_STS=id_sts

RUN /opt/glassfish4/glassfish/bin/asadmin create-domain --portbase 8800 --nopassword=true app-domain && \
	mkdir /opt/properties && \
	mkdir /opt/sso && \
	mkdir /opt/certs && \
	mkdir /opt/key

COPY cacerts.jks_app /opt/glassfish4/glassfish/domains/app-domain/config/cacerts.jks
COPY keystore.jks_app /opt/glassfish4/glassfish/domains/app-domain/config/keystore.jks
	
COPY oscm-app.ear oscm-app-aws.ear oscm-app-openstack.ear /opt/glassfish4/glassfish/domains/app-domain/autodeploy/

COPY sqlscripts/*.sql /opt/sqlscripts/
COPY templates/*.template /opt/templates/
COPY oscm-devruntime.jar /opt/

COPY oscm-common.jar oscm-extsvc-internal.jar oscm-extsvc-platform.jar oscm-server-common.jar /opt/lib/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
