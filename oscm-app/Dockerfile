FROM oscm-gf

RUN /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8800 --user admin --nopassword=true app-domain && \
    mkdir sqlscripts && \
    ln -s config/master-password /opt/glassfish3/glassfish/domains/app-domain/master-password

COPY oscm-app.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-app-aws.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-app-openstack.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY sqlscripts/*.sql sqlscripts/
COPY oscm-devruntime.jar /opt/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
