FROM oscm-gf

ENV TARGET=CORE SOURCE=INIT OVERWRITE=false DB_SUPERUSER=postgres PGPASSWORD=postgres
ENV DB_HOST_CORE=oscm-db DB_PORT_CORE=5432 DB_NAME_CORE=bss DB_USER_CORE=bssuser DB_PWD_CORE=bssuser
ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser 
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser 
ENV SQL_DUMP_GLOBALS=globals.sql SQL_DUMP_BSS=bss.sql SQL_DUMP_BSSJMS=bssjms.sql SQL_DUMP_BSSAPP=bssapp.sql

ENV AUTH_MODE=INTERNAL BASE_URL=http://localhost/oscm-portal BASE_URL_HTTPS=https://localhost/oscm-portal LOG_LEVEL=INFO KEY_FILE_PATH=/opt/apache-tomee-plume-7.0.3/bin/key
ENV REPORT_ENGINEURL=http://engi.ne/url REPORT_WSDLURL=http://engi.ne/url?wsdl REPORT_SOAP_ENDPOINT=http://soap.engi.ne/url CUSTOMER_SELF_REGISTRATION_ENABLED=false
ENV SSO_IDP_URL=http://idp.com SSO_IDP_AUTHENTICATION_REQUEST_HTTP_METHOD=POST SSO_ISSUER_ID=issuer SSO_STS_ENCKEY_LEN=256 SSO_STS_URL=http://sts.example.com SSO_STS_METADATA_URL=http://meta.com
ENV SSO_DEFAULT_TENANT_ID=dftenant SSO_IDP_SAML_ASSERTION_ISSUER_ID=issuer SSO_LOGOUT_URL=url ADMIN_USER_ID=administrator

ENV APP_BASE_URL=http://localhost/oscm-app APP_ADMIN_MAIL_ADDRESS=admin@mail.com APP_TRUSTSTORE_BSS_ALIAS=core-s1as
ENV APP_USER_KEY=1000 APP_USER_NAME=administrator APP_USER_PWD=admin123 CORE_ID_SERVICE=id CORE_ID_SERVICE_WSDL=id?wsdl CORE_ID_SERVICE_STS=id_sts CORE_ID_SERVICE_STS_WSDL=id_sts?wsdl

ENV CONTROLLER_ID=ess.sample CONTROLLER_ORG_ID=orgid123 CONTROLLER_USER_KEY=1000 CONTROLLER_USER_NAME=administrator CONTROLLER_USER_PASS=admin123

COPY sqlscripts/core/*.sql /opt/sqlscripts/core/
COPY sqlscripts/app/*.sql /opt/sqlscripts/app/
COPY templates/*.template /opt/templates/
COPY oscm-devruntime.jar oscm-app.jar /opt/

COPY resources/accesscontrol.properties resources/passwd /opt/glassfish4/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/etc/
COPY resources/accesscontrol.properties resources/passwd /opt/glassfish4/glassfish/domains/core-domain/imq/instances/imqbroker/etc/
COPY resources/config.properties /opt/glassfish4/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props/
COPY resources/config.properties /opt/glassfish4/glassfish/domains/core-domain/imq/instances/imqbroker/props/

COPY oscm-common.jar oscm-server-common.jar oscm-extsvc-platform.jar oscm-extsvc-internal.jar log4j-1.2.16.jar postgresql-9.4-1206-jdbc42.jar commons-validator-1.4.0.jar commons-logging-1.1.3.jar jakarta-oro-2.0.8.jar /opt/lib/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
