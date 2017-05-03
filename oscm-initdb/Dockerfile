FROM centos:7

ENV INIT_BES false
ENV INIT_APP false
ENV DB_SUPERUSER postgres
ENV PGPASSWORD postgres

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum -y update && \
    yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel unzip wget postgresql96 && \
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
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/bes-domain/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/app-domain/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/ext/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/master-indexer-domain/lib/databases/postgresql-9.1-903.jdbc4.jar

COPY sqlscripts/bes/*.sql /opt/sqlscripts/bes/
COPY sqlscripts/app/*.sql /opt/sqlscripts/app/
COPY oscm-devruntime.jar /opt/
COPY oscm-app.jar /opt/
COPY oscm-common.jar /opt/lib
COPY oscm-server-common.jar /opt/lib
COPY log4j-1.2.16.jar /opt/lib
COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib
COPY commons-validator-1.4.0.jar /opt/lib
COPY commons-logging-1.1.3.jar /opt/lib
COPY oro-2.0.8.jar /opt/lib
COPY oscm-extsvc-platform.jar /opt/lib
COPY oscm-extsvc-internal.jar /opt/lib

COPY accesscontrol.properties /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/etc/
COPY config.properties.jms.template /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props/config.properties
COPY passwd.jms /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/etc/passwd

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
