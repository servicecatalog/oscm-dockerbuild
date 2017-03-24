FROM oscm-gf

RUN /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8400 --user admin --nopassword=true master-indexer-domain && \
    /opt/glassfish3/glassfish/bin/asadmin create-domain --portbase 8000 --user admin --nopassword=true bes-domain && \
	wget http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/R-R1-4_2_2-201302161152/birt-runtime-4_2_2.zip && \
	unzip birt-runtime-4_2_2.zip -d /tmp/ && \
	cp /tmp/birt-runtime-4_2_2/birt.war /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/ && \
	rm -rf /tmp/birt-runtime-4_2_2/ && \
	mkdir /opt/sqlscripts

COPY oscm-search.ear /opt/glassfish3/glassfish/domains/master-indexer-domain/autodeploy/
COPY oscm-sso.ear /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/
COPY oscm-portal.war /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/
COPY oscm-portal-help.war /opt/glassfish3/glassfish/domains/bes-domain/autodeploy/
COPY oscm-reports.zip /tmp/
COPY sqlscripts/*.sql /opt/sqlscripts/
COPY oscm-devruntime.jar /opt/

COPY oscm-security.jar /opt/glassfish3/glassfish/domains/bes-domain/lib/
COPY commons-codec-1.7.jar /opt/glassfish3/glassfish/domains/bes-domain/lib/

COPY start.sh /opt/

CMD ["/opt/start.sh"]
