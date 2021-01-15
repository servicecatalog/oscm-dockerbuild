 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM oscm-gf

ENV TARGET=CORE SOURCE=INIT OVERWRITE=false DB_SUPERUSER=postgres DB_SUPERPWD=postgres
ENV DB_HOST_CORE=oscm-db DB_PORT_CORE=5432 DB_NAME_CORE=bss DB_USER_CORE=bssuser DB_PWD_CORE=bssuser
ENV DB_NAME_APPROVAL=approvaldb DB_USER_APPROVAL=approvaluser DB_PWD_APPROVAL=approvaluser
ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV SQL_DUMP_GLOBALS=globals.sql SQL_DUMP_BSS=bss.sql SQL_DUMP_BSSJMS=bssjms.sql SQL_DUMP_BSSAPP=bssapp.sql

ENV LOG_LEVEL=INFO
ENV LOG_FILE_PATH=../logs
ENV LOG_CONFIG_FILE=./log4j.properties
ENV REPORT_ENGINEURL=https://${HOST_FQDN}:8681/birt/frameset?__report=\${reportname}.rptdesign&SessionId=\${sessionid}&__locale=\${locale}&WSDLURL=\${wsdlurl}&SOAPEndPoint=\${soapendpoint}&wsname=Report&wsport=ReportPort
ENV MP_ERROR_REDIRECT_HTTPS=https://${HOST_FQDN}:8081/oscm-portal/marketplace?mId=959c9bf7

ENV DECIMAL_PLACES=2
ENV MAIL_JA_CHARSET=UTF-8
ENV MAX_NUMBER_LOGIN_ATTEMPTS=3
ENV PERMITTED_PERIOD_UNCONFIRMED_ORGANIZATIONS=604800000
ENV MAX_NUMBER_ALLOWED_USERS=1000

ENV TIMER_INTERVAL_SUBSCRIPTION_EXPIRATION=86400000
ENV TIMER_INTERVAL_ORGANIZATION_OFFSET=0
ENV TIMER_INTERVAL_ORGANIZATION=0
ENV TIMER_INTERVAL_USER_COUNT=43200000
ENV TIMER_INTERVAL_SUBSCRIPTION_EXPIRATION_OFFSET=0
ENV TIMER_INTERVAL_TENANT_PROVISIONING_TIMEOUT=0
ENV TIMER_INTERVAL_TENANT_PROVISIONING_TIMEOUT_OFFSET=0
ENV TIMER_INTERVAL_DISCOUNT_END_NOTIFICATION_OFFSET=0
ENV TIMER_INTERVAL_BILLING_OFFSET=345600000
ENV TIMER_INTERVAL_INACTIVE_ON_BEHALF_USERS=0
ENV TIMER_INTERVAL_INACTIVE_ON_BEHALF_USERS_OFFSET=0
ENV TIMER_INTERVAL_DISCOUNT_END_NOTIFICATION_OFFSET=0

ENV PSP_USAGE_ENABLED=false
ENV HIDDEN_UI_ELEMENTS=operator.manageBillingAdapters,techService.viewBillingAdapters
ENV WS_TIMEOUT=30000
ENV AUDIT_LOG_ENABLED=false
ENV AUDIT_LOG_MAX_ENTRIES_RETRIEVED=100

ENV REPORT_WSDLURL=http://oscm-core:8080/oscm-reporting/ReportingServiceBean?wsdl
ENV REPORT_SOAP_ENDPOINT=http://oscm-core:8080/oscm-reporting/ReportingServiceBean CUSTOMER_SELF_REGISTRATION_ENABLED=false

ENV APP_ADMIN_MAIL_ADDRESS=admin@mail.com APP_TRUSTSTORE_BSS_ALIAS=core-s1as
ENV APP_USER_KEY=1000 APP_USER_NAME=administrator APP_USER_PWD=admin123 CORE_ID_SERVICE=http://oscm-core:8080/oscm-webservices/{SERVICE}/BASIC CORE_ID_SERVICE_WSDL=http://oscm-core:8080/oscm-webservices/{SERVICE}/BASIC?wsdl CORE_ID_SERVICE_STS=http://oscm-core:8080/oscm-webservices/{SERVICE}/STS CORE_ID_SERVICE_STS_WSDL=http://oscm-core:8080/oscm-webservices/{SERVICE}/STS?wsdl

ENV CONTROLLER_ID=ess.sample CONTROLLER_ORG_ID=PLATFORM_OPERATOR CONTROLLER_USER_KEY=1000 CONTROLLER_USER_NAME=administrator CONTROLLER_USER_PASS=admin123

ENV CUSTOM_DATA=false

COPY sqlscripts/core/*.sql /opt/sqlscripts/core/
COPY sqlscripts/app/*.sql /opt/sqlscripts/app/
COPY sqlscripts/vmware/*.sql /opt/sqlscripts/vmware/
COPY sqlscripts/approval/*.sql /opt/sqlscripts/approval/
COPY templates/*.template /opt/templates/
COPY oscm-devruntime.jar oscm-app.jar /opt/

COPY oscm-common.jar oscm-server-common.jar oscm-extsvc-platform.jar oscm-extsvc-internal.jar log4j-api-2.13.0.jar log4j-core-2.13.0.jar postgresql-9.4-1206-jdbc42.jar commons-validator-1.4.0.jar commons-logging-1.1.3.jar jakarta-oro-2.0.8.jar /opt/lib/

COPY start.sh /opt/
RUN mkdir /opt/sqlscripts/custom && chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
