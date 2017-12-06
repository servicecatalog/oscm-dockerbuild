FROM oscm-gf

ENV TARGET=CORE SOURCE=INIT OVERWRITE=false DB_SUPERUSER=postgres DB_SUPERPWD=postgres
ENV DB_HOST_CORE=oscm-db DB_PORT_CORE=5432 DB_NAME_CORE=bss DB_USER_CORE=bssuser DB_PWD_CORE=bssuser
ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser 
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser 
ENV SQL_DUMP_GLOBALS=globals.sql SQL_DUMP_BSS=bss.sql SQL_DUMP_BSSJMS=bssjms.sql SQL_DUMP_BSSAPP=bssapp.sql

ENV AUTH_MODE=INTERNAL HOST_FQDN=localhost LOG_LEVEL=INFO
ENV REPORT_ENGINEURL=https://${HOST_FQDN}:8681/birt/frameset?__report=\${reportname}.rptdesign&SessionId=\${sessionid}&__locale=\${locale}&WSDLURL=\${wsdlurl}&SOAPEndPoint=\${soapendpoint}&wsname=Report&wsport=ReportPort

ENV REPORT_WSDLURL=http://oscm-core:8080/oscm-reporting/ReportingServiceBean?wsdl
ENV REPORT_SOAP_ENDPOINT=http://oscm-core:8080/oscm-reporting/ReportingServiceBean CUSTOMER_SELF_REGISTRATION_ENABLED=false
ENV SSO_IDP_URL=http://idp.com SSO_IDP_AUTHENTICATION_REQUEST_HTTP_METHOD=POST SSO_ISSUER_ID=issuer SSO_STS_ENCKEY_LEN=256 SSO_STS_URL=http://sts.example.com SSO_STS_METADATA_URL=http://meta.com
ENV SSO_DEFAULT_TENANT_ID=dftenant SSO_IDP_SAML_ASSERTION_ISSUER_ID=issuer SSO_LOGOUT_URL=https://idp.com/logout ADMIN_USER_ID=administrator

ENV APP_ADMIN_MAIL_ADDRESS=admin@mail.com APP_TRUSTSTORE_BSS_ALIAS=core-s1as
ENV APP_USER_KEY=1000 APP_USER_NAME=administrator APP_USER_PWD=admin123 CORE_ID_SERVICE=http://oscm-core:8080/oscm-webservices/{SERVICE}/BASIC CORE_ID_SERVICE_WSDL=http://oscm-core:8080/oscm-webservices/{SERVICE}/BASIC?wsdl CORE_ID_SERVICE_STS=http://oscm-core:8080/oscm-webservices/{SERVICE}/STS CORE_ID_SERVICE_STS_WSDL=http://oscm-core:8080/oscm-webservices/{SERVICE}/STS?wsdl

ENV CONTROLLER_ID=ess.sample CONTROLLER_ORG_ID=PLATFORM_OPERATOR CONTROLLER_USER_KEY=1000 CONTROLLER_USER_NAME=administrator CONTROLLER_USER_PASS=admin123

ENV CUSTOM_DATA=false

#COPY sqlscripts/core/*.sql /opt/sqlscripts/core/
#COPY sqlscripts/app/*.sql /opt/sqlscripts/app/
COPY templates/*.template /opt/templates/

COPY flyway.tar.gz /opt/

COPY libs/commons-logging.jar    /opt/core-flyway-jars/
COPY libs/commons-validator.jar    /opt/core-flyway-jars/
COPY libs/log4j.jar    /opt/core-flyway-jars/
COPY libs/oro.jar    /opt/core-flyway-jars/
COPY libs/oscm-common.jar    /opt/core-flyway-jars/
COPY libs/oscm-devruntime.jar    /opt/core-flyway-jars/
COPY libs/oscm-extsvc.jar    /opt/core-flyway-jars/
COPY libs/oscm-extsvc-internal.jar    /opt/core-flyway-jars/

COPY libs/oscm-app.jar /opt/flyway-app-jars/

COPY start.sh /opt/
#RUN mkdir /opt/sqlscripts/custom &&
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
