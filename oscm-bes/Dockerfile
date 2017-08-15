FROM oscm-gf

RUN mkdir /opt/apache-tomee-plume-7.0.3/apps

COPY oscm.ear /opt/apache-tomee-plume-7.0.3/apps
COPY oscm-portal.war /opt/apache-tomee-plume-7.0.3/webapps

COPY oscm-security.jar /opt/apache-tomee-plume-7.0.3/lib/

COPY resources/jaas.config /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/server.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/setenv.sh /opt/apache-tomee-plume-7.0.3/bin/
COPY resources/system.properties /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomee.xml /opt/apache-tomee-plume-7.0.3/conf/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
