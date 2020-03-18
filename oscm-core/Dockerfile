FROM oscm-gf

RUN mkdir /opt/apache-tomee/apps
RUN mkdir -p /templates/WEB-INF

ENV KEY_SECRET=secretsecret1234 DOMAIN_PWD=adminadmin CERT_FILE=s1as.crt
ENV DB_HOST_CORE=oscm-db DB_PORT_CORE=5432 DB_NAME_CORE=bss DB_USER_CORE=bssuser DB_PWD_CORE=bssuser
ENV DB_TIMEOUT_CORE=300 DB_WAIT_CORE=60000 DB_RETRY_INTERVAL_CORE=10 DB_TIMEOUT_MI=300 DB_WAIT_MI=60000 DB_RETRY_INTERVAL_MI=10
ENV DB_HOST_JMS=oscm-db DB_PORT_JMS=5432 DB_NAME_JMS=bssjms DB_USER_JMS=jmsuser DB_PWD_JMS=jmsuser
ENV SMTP_HOST=localhost SMTP_PORT=25 SMTP_FROM=mail@oscm.org SMTP_USER=saas SMTP_AUTH=false SMTP_PWD=secret SMTP_TLS=false
ENV CONTAINER_CALLBACK_THREADS=50 CONTAINER_MAX_SIZE=50

COPY resources/web.xml /templates/WEB-INF
COPY oscm.ear /opt/apache-tomee/apps
COPY oscm-portal.war /opt/apache-tomee/webapps
COPY oscm-portal-help.war /opt/apache-tomee/webapps

COPY oscm-rest-api.war /opt/apache-tomee/webapps

COPY oscm-security.jar /opt/apache-tomee/lib/
COPY oscm-common.jar /opt/apache-tomee/lib/
COPY oscm-rest-api-common.jar /opt/apache-tomee/lib/

COPY resources/jaas.config /opt/apache-tomee/conf/
COPY resources/server.xml /opt/apache-tomee/conf/
COPY resources/setenv.sh /opt/apache-tomee/bin/
COPY resources/system.properties /opt/apache-tomee/conf/
COPY resources/tomcat-users.xml /opt/apache-tomee/conf/
COPY resources/tomee_template.xml /opt/apache-tomee/conf/
COPY resources/key /opt/apache-tomee/bin/
COPY resources/web.xml /templates/WEB-INF
COPY resources/catalina.properties /opt/apache-tomee/conf/catalina.properties
COPY resources/context.xml /opt/apache-tomee/conf/context.xml
COPY resources/Sample.yaml /templates/

COPY hibernate-commons-annotations-5.0.1.Final.jar /opt/apache-tomee/lib/hibernate-commons-annotations-5.0.1.Final.jar
COPY hibernate-core-5.0.9.Final.jar /opt/apache-tomee/lib/hibernate-core-5.0.9.Final.jar
COPY hibernate-entitymanager-5.0.9.Final.jar /opt/apache-tomee/lib/hibernate-entitymanager-5.0.9.Final.jar
COPY hibernate-jpa-2.1-api-1.0.0.Final.jar /opt/apache-tomee/lib/hibernate-jpa-2.1-api-1.0.0.Final.jar
COPY jackson-annotations.jar /opt/apache-tomee/lib/jackson-annotations.jar
COPY jackson-core.jar /opt/apache-tomee/lib/jackson-core.jar
COPY jackson-databind.jar /opt/apache-tomee/lib/jackson-databind.jar
COPY hibernate-search-orm-5.5.4.Final.jar /opt/apache-tomee/lib/hibernate-search-orm-5.5.4.Final.jar
COPY hibernate-search-engine-5.5.4.Final.jar /opt/apache-tomee/lib/hibernate-search-engine-5.5.4.Final.jar
COPY postgresql-9.4-1206-jdbc42.jar /opt/apache-tomee/lib/postgresql-9.4-1206-jdbc42.jar
COPY lucene-analyzers-common-5.3.1.jar /opt/apache-tomee/lib/lucene-analyzers-common-5.3.1.jar
COPY lucene-backward-codecs-5.3.1.jar /opt/apache-tomee/lib/lucene-backward-codecs-5.3.1.jar
COPY lucene-core-5.3.1.jar /opt/apache-tomee/lib/lucene-core-5.3.1.jar
COPY lucene-facet-5.3.1.jar /opt/apache-tomee/lib/lucene-facet-5.3.1.jar
COPY lucene-misc-5.3.1.jar /opt/apache-tomee/lib/lucene-misc-5.3.1.jar
COPY lucene-queries-5.3.1.jar /opt/apache-tomee/lib/lucene-queries-5.3.1.jar
COPY solr-core-5.3.1.jar /opt/apache-tomee/lib/solr-core-5.3.1.jar
COPY solr-solrj-5.3.1.jar /opt/apache-tomee/lib/solr-solrj-5.3.1.jar
COPY lucene-queryparser-5.3.1.jar /opt/apache-tomee/lib/lucene-queryparser-5.3.1.jar
COPY dom4j-1.6.1.jar /opt/apache-tomee/lib/dom4j-1.6.1.jar
COPY antlr-2.7.7.jar /opt/apache-tomee/lib/antlr-2.7.7.jar
COPY log4j-api-2.13.0.jar /opt/apache-tomee/lib/log4j-api-2.13.0.jar
COPY log4j-core-2.13.0.jar /opt/apache-tomee/lib/log4j-core-2.13.0.jar
COPY gson-2.6.2.jar /opt/apache-tomee/lib/gson-2.6.2.jar

COPY ssl.key ssl.crt /opt/
COPY ssl.crt /import/certs/
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
