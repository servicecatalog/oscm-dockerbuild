FROM oscm-gf

RUN /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8800 app-domain

COPY oscm-app.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-aws.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/
COPY oscm-openstack.ear /opt/glassfish3/glassfish/domains/app-domain/autodeploy/

COPY start.sh /opt/
RUN chmod a+x /opt/start.sh

CMD ["/opt/start.sh"]
