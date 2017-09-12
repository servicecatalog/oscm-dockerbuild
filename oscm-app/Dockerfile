FROM oscm-gf

RUN mkdir /opt/apache-tomee-plume-7.0.3/apps

ENV AUTH_MODE=INTERNAL KEY_SECRET=secret DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt IDP_WSDL_URL=dummy IDP_TARGET_NAMESPACE=dummy
ENV DB_HOST_APP=oscm-db DB_PORT_APP=5432 DB_NAME_APP=bssapp DB_USER_APP=bssappuser DB_PWD_APP=bssappuser
ENV DB_TIMEOUT_APP=300 DB_WAIT_APP=60000 DB_RETRY_INTERVAL_APP=10
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret

COPY oscm-app.ear oscm-app-aws.ear oscm-app-openstack.ear /opt/apache-tomee-plume-7.0.3/apps/
COPY hibernate-commons-annotations-5.0.1.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-commons-annotations-5.0.1.Final.jar
COPY hibernate-core-5.0.9.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-core-5.0.9.Final.jar
COPY hibernate-entitymanager-5.0.9.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-entitymanager-5.0.9.Final.jar
COPY hibernate-jpa-2.1-api-1.0.0.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-jpa-2.1-api-1.0.0.Final.jar
COPY jackson-annotations.jar /opt/apache-tomee-plume-7.0.3/lib/jackson-annotations.jar
COPY jackson-core.jar /opt/apache-tomee-plume-7.0.3/lib/jackson-core.jar
COPY jackson-databind.jar /opt/apache-tomee-plume-7.0.3/lib/jackson-databind.jar
COPY hibernate-search-orm-5.5.4.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-search-orm-5.5.4.Final.jar
COPY hibernate-search-engine-5.5.4.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-search-engine-5.5.4.Final.jar
COPY postgresql-9.4-1206-jdbc42.jar /opt/apache-tomee-plume-7.0.3/lib/postgresql-9.4-1206-jdbc42.jar
COPY lucene-analyzers-common-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-analyzers-common-5.3.1.jar
COPY lucene-backward-codecs-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-backward-codecs-5.3.1.jar
COPY lucene-core-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-core-5.3.1.jar
COPY lucene-facet-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-facet-5.3.1.jar
COPY lucene-misc-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-misc-5.3.1.jar
COPY lucene-queries-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-queries-5.3.1.jar
COPY solr-core-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/solr-core-5.3.1.jar
COPY solr-solrj-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/solr-solrj-5.3.1.jar
COPY lucene-queryparser-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-queryparser-5.3.1.jar

COPY resources/server.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/system.properties /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee-plume-7.0.3/conf/
COPY resources/tomee.xml /opt/apache-tomee-plume-7.0.3/conf/

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
