FROM oscm-gf

RUN /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8400 master-indexer-domain && \
    /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8000 bes-domain

COPY oscm-search.ear /opt/glassfish3/glassfish/domains/master-indexer-domain/autodeploy/
COPY oscm.ear /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/
COPY oscm-portal.war /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/
COPY oscm-portal-help.war /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/
COPY birt.war /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/

COPY oscm-security.jar /opt/glassfish3/glassfish/domains/bes-domain/lib
COPY commons-codec-1.7.jar /opt/glassfish3/glassfish/domains/bes-domain/lib
    	
COPY start.sh /opt/
RUN chmod a+x /opt/start.sh

CMD ["/opt/start.sh"]
