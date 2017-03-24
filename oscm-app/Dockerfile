FROM oscm-gf

RUN /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8800 --user admin --nopassword=true app-domain && \
    mkdir sqlscripts

COPY oscm-app.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-aws.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-openstack.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY sqlscripts/*.sql sqlscripts/
COPY oscm-devruntime.jar /opt/

COPY start.sh /opt/

CMD ["/opt/start.sh"]
