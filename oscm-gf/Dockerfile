FROM oscm-sles-based

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper -n in gettext-runtime vim postgresql94 java-1_8_0-openjdk java-1_8_0-openjdk-devel && \
    zypper clean && \
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi && \
    wget http://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/7.0.3/apache-tomee-7.0.3-plume.zip -O /tmp/apache-tomee-7.0.3-plume.zip && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-157.jar -O /usr/lib64/jvm/java-1.8.0-openjdk/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib64/jvm/java-1.8.0-openjdk/jre/lib/security/java.security && \
    unzip /tmp/apache-tomee-7.0.3-plume.zip -d /opt/ && \
    rm /tmp/apache-tomee-7.0.3-plume.zip

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
COPY dom4j-1.6.1.jar /opt/apache-tomee-plume-7.0.3/lib/dom4j-1.6.1.jar
COPY antlr-2.7.7.jar /opt/apache-tomee-plume-7.0.3/lib/antlr-2.7.7.jar