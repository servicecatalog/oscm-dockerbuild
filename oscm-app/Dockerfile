FROM oscm-gf

RUN /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8800 --user admin --nopassword=true app-domain && \
    mkdir sqlscripts && \
    mkdir /opt/lib && \
    ln -s config/master-password /opt/glassfish3/glassfish/domains/app-domain/master-password && \
    rm -f /opt/jks/*mi && \
    rm -f /opt/jks/*bes

COPY oscm-app.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-app-aws.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-app-openstack.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY sqlscripts/*.sql sqlscripts/
COPY oscm-devruntime.jar /opt/

COPY oscm-common.jar /opt/lib
COPY log4j-1.2.16.jar /opt/lib
COPY postgresql-9.1-903.jdbc4.jar /opt/lib
COPY oscm-extsvc-internal.jar /opt/lib

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
