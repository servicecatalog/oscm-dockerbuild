 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM oscm-gf

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo && \
    yum install -y --no-install-recommends powershell && \
    pwsh -Command Set-PSRepository -Name PSGallery -InstallationPolicy Trusted && \
    pwsh -Command Install-Module Az && \
    mkdir /opt/apache-tomee/apps && \
    mkdir /opt/apache-tomee/controllers && \
    mkdir /opt/properties && \
    mkdir /opt/sso && \
    mkdir /opt/certs && \
    mkdir /opt/key && \
    mkdir /opt/scripts

ENV AUTH_MODE=INTERNAL KEY_SECRET=secretsecret1234 DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt IDP_WSDL_URL=dummy IDP_TARGET_NAMESPACE=dummy
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV DB_TIMEOUT_APP=300 DB_WAIT_APP=60000 DB_RETRY_INTERVAL_APP=10
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret SMTP_TLS=false
ENV CONTAINER_CALLBACK_THREADS=50 CONTAINER_MAX_SIZE=50
ENV PROXY_ENABLED=true PROXY_HTTP_HOST=none PROXY_HTTP_PORT=0 PROXY_HTTPS_HOST=none PROXY_HTTPS_PORT=0 PROXY_NOPROXY=oscm-core

COPY resources/server.xml /opt/apache-tomee/conf/
COPY resources/system.properties /opt/apache-tomee/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee/conf/
COPY resources/tomee_template.xml /opt/apache-tomee/conf/
COPY resources/tomee.xml /opt/apache-tomee/conf/
COPY resources/key ./
COPY resources/catalina_template.properties /opt/apache-tomee/conf/catalina_template.properties
COPY resources/context.xml /opt/apache-tomee/conf/context.xml
COPY resources/catalina_template.sh /opt/apache-tomee/bin/catalina_template.sh

COPY oscm-app.ear /opt/apache-tomee/apps/
COPY oscm-app-sample.ear oscm-app-openstack.ear oscm-app-aws.ear oscm-app-azure.ear oscm-app-vmware.ear oscm-app-approval.ear /opt/apache-tomee/controllers/
COPY oscm-app-shell.war /opt/apache-tomee/webapps/
COPY approval-impl-0.0.2-SNAPSHOT.war /opt/apache-tomee/webapps/approval.war

COPY postgresql-9.4-1206-jdbc42.jar /opt/apache-tomee/lib/postgresql-9.4-1206-jdbc42.jar
COPY oscm-app-extsvc-2-0.jar /opt/apache-tomee/lib/oscm-app-extsvc-2-0.jar
COPY log4j-api-2.13.0.jar /opt/apache-tomee/lib/log4j-api-2.13.0.jar
COPY log4j-core-2.13.0.jar /opt/apache-tomee/lib/log4j-core-2.13.0.jar

COPY ssl.key ssl.crt /opt/
COPY ssl.crt /import/certs/
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors

COPY start.sh /opt/
RUN chmod +x /opt/start.sh && \
    chmod +x /opt/apache-tomee/bin/catalina_template.sh

CMD ["/opt/start.sh"]
