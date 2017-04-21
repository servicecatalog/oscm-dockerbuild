FROM oscm-gf

RUN /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8800 --user admin --nopassword=true app-domain && \
    mkdir /opt/sqlscripts && \
    mkdir /opt/lib && \
    mkdir -p /opt/glassfish3/glassfish/domains/app-domain/lib && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/domains/app-domain/lib/postgresql-9.1-903.jdbc4.jar && \
    ln -s config/master-password /opt/glassfish3/glassfish/domains/app-domain/master-password && \
    ln -s ../config/OSCM-wsit.jar /opt/glassfish3/glassfish/domains/app-domain/lib/OSCM-wsit.jar

COPY oscm-app.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-app-aws.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-app-openstack.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY sqlscripts/*.sql /opt/sqlscripts/
COPY oscm-devruntime.jar /opt/

COPY oscm-common.jar /opt/lib
COPY log4j-1.2.16.jar /opt/lib
COPY oscm-extsvc-internal.jar /opt/lib

COPY cacerts.jks_app /opt/glassfish3/glassfish/domains/app-domain/config/cacerts.jks
COPY keystore.jks_app /opt/glassfish3/glassfish/domains/app-domain/config/keystore.jks

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
