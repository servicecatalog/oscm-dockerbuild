FROM centos:7

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum -y update && \
    yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel zip unzip wget postgresql96 gettext vim-common nc && \
    yum clean all && \
    wget http://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/7.0.3/apache-tomee-7.0.3-plume.zip -O /tmp/apache-tomee-7.0.3-plume.zip && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-156.jar -O /usr/lib/jvm/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib/jvm/jre/lib/security/java.security && \
    unzip /tmp/apache-tomee-7.0.3-plume.zip -d /opt/ && \
    rm /tmp/apache-tomee-7.0.3-plume.zip

COPY hibernate-commons-annotations-5.0.1.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-commons-annotations-5.0.1.Final.jar
COPY hibernate-core-5.0.9.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-core-5.0.9.Final.jar
COPY hibernate-entitymanager-5.0.9.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-entitymanager-5.0.9.Final.jar
COPY hibernate-jpa-2.1-api-1.0.0.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-jpa-2.1-api-1.0.0.Final.jar
COPY jackson-annotations-2.5.1.jar /opt/apache-tomee-plume-7.0.3/lib/jackson-annotations-2.5.1.jar
COPY jackson-core-2.5.1.jar /opt/apache-tomee-plume-7.0.3/lib/jackson-core-2.5.1.jar
COPY jackson-databind-2.5.1.jar /opt/apache-tomee-plume-7.0.3/lib/jackson-databind-2.5.1.jar
COPY jboss-logging-3.3.0.Final.jar /opt/apache-tomee-plume-7.0.3/lib/jboss-logging-3.3.0.Final.jar
COPY dom4j-1.6.1.jar /opt/apache-tomee-plume-7.0.3/lib/dom4j-1.6.1.jar
COPY hibernate-search-orm-5.5.4.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-search-orm-5.5.4.Final.jar
COPY hibernate-search-engine-5.5.4.Final.jar /opt/apache-tomee-plume-7.0.3/lib/hibernate-search-engine-5.5.4.Final.jar
COPY postgresql-9.4-1206-jdbc42.jar /opt/apache-tomee-plume-7.0.3/lib/postgresql-9.4-1206-jdbc42.jar
COPY lucene-analyzers-common-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-analyzers-common-5.3.1.jar
COPY lucene-backward-codecs-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-backward-codecs-5.3.1.jar
COPY lucene-core-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-core-5.3.1.jar
COPY lucene-facet-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-facet-5.3.1.jar
COPY lucene-misc-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-misc-5.3.1.jar
COPY lucene-queries-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-queries-5.3.1.jar
COPY lucene-queryparser-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/lucene-queryparser-5.3.1.jar
COPY solr-core-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/solr-core-5.3.1.jar
COPY solr-solrj-5.3.1.jar /opt/apache-tomee-plume-7.0.3/lib/solr-solrj-5.3.1.jar
COPY antlr4-runtime-4.1.jar /opt/apache-tomee-plume-7.0.3/lib/antlr4-runtime-4.1.jar

COPY oscm-security.jar /opt/apache-tomee-plume-7.0.3/lib/oscm-security.jar
