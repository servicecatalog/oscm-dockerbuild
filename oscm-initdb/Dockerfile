FROM centos:7

ENV INIT_BES=false INIT_APP=false INIT_CONTROLLER=false IMPORT_DB=false DB_SUPERUSER=postgres PGPASSWORD=postgres DB_HOST_BES=oscm-dbc DB_PORT_BES=5432 DB_NAME_BES=bss DB_USER_BES=bssuser DB_PWD_BES=bssuser DB_HOST_APP=oscm-dbc DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser HOSTNAME_BES=localhost HOSTNAME_APP=localhost APP_ORGADMIN_USER_KEY=1000 APP_ORGADMIN_USER_NAME=administrator APP_ORGADMIN_USER_PASS=admin123 APP_KEYSTORE_PASSWORD=changeit APP_TRUSTSTORE_PASSWORD=changeit APP_TECHPROV_USER_KEY=10000 APP_TECHPROV_USER_NAME=opsorg APP_TECHPROV_USER_PASS=secret

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum -y update && \
    yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel unzip wget postgresql96 gettext && \
    yum clean all && \
    wget http://download.java.net/glassfish/3.1.2/release/glassfish-3.1.2.zip -O /tmp/glassfish.zip && \
    unzip /tmp/glassfish.zip -d /opt/ && \
	rm -rf /opt/glassfish3/glassfish/domains/domain1 && \
    rm /tmp/glassfish.zip && \
    mkdir -p /opt/sqlscripts/bes && \
    mkdir -p /opt/sqlscripts/app && \
	mkdir /opt/lib && \
    mkdir -p /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/etc && \
    mkdir /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props && \
    mkdir -p /opt/glassfish3/mq/lib/ext && \
    mkdir -p /opt/glassfish3/glassfish/lib && \
    mkdir -p /opt/glassfish3/glassfish/domains/bes-domain/lib && \
    mkdir -p /opt/glassfish3/glassfish/domains/app-domain/lib && \
    mkdir -p /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/ext && \
    mkdir -p /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/databases && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/mq/lib/ext/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/bes-domain/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/app-domain/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/ext/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/databases/postgresql-9.1-903.jdbc4.jar

COPY sqlscripts/bes/*.sql /opt/sqlscripts/bes/
COPY sqlscripts/app/*.sql /opt/sqlscripts/app/
# COPY oscm-devruntime.jar /opt/
# COPY oscm-app.jar /opt/
# COPY oscm-common.jar /opt/lib
# COPY oscm-server-common.jar /opt/lib
# COPY log4j-1.2.16.jar /opt/lib
# COPY commons-validator-1.4.0.jar /opt/lib
# COPY commons-logging-1.1.3.jar /opt/lib
# COPY oro-2.0.8.jar /opt/lib
# COPY oscm-extsvc-platform.jar /opt/lib
# COPY oscm-extsvc-internal.jar /opt/lib
COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib
COPY accesscontrol.properties /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/etc/
COPY passwd.jms /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/etc/passwd
COPY ["oscm-common.jar", "oscm-server-common.jar", "log4j-1.2.16.jar", "commons-validator-1.4.0.jar", "commons-logging-1.1.3.jar", "oro-2.0.8.jar", "oscm-extsvc-platform.jar", "oscm-extsvc-internal.jar", "/opt/lib/"]
COPY ["config.properties.jms.template", "db.properties.bes.template", "db.properties.app.template", "configsettings.properties.bes.template", "configsettings.properties.app.template", "configsettings_controller.properties.app.template", "/propertytemplates/"]
COPY ["oscm-devruntime.jar", "oscm-app.jar", "start.sh", "/opt/"]
# COPY config.properties.jms.template /propertytemplates/
# COPY db.properties.bes.template /propertytemplates/
# COPY db.properties.app.template /propertytemplates/
# COPY configsettings.properties.bes.template /propertytemplates/
# COPY configsettings.properties.app.template /propertytemplates/
# COPY configsettings_controller.properties.app.template /propertytemplates/

#COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
