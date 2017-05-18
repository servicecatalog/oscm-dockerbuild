FROM centos:7

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum -y update && \
    yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel zip unzip wget postgresql96 gettext && \
    yum clean all && \
    wget http://download.java.net/glassfish/4.1.2/release/glassfish-4.1.2.zip -O /tmp/glassfish.zip && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-156.jar -O /usr/lib/jvm/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib/jvm/jre/lib/security/java.security && \
    unzip /tmp/glassfish.zip -d /opt/ && \
	rm -rf /opt/glassfish4/glassfish/domains/domain1 && \
    rm /tmp/glassfish.zip

COPY postgresql-9.4-1206-jdbc42.jar /opt/glassfish4/mq/lib/ext/
COPY postgresql-9.4-1206-jdbc42.jar commons-codec-1.7.jar lucene-analyzers-common-5.3.1.jar lucene-core-5.3.1.jar /opt/glassfish4/glassfish/lib/
COPY jboss-logging.jar org.eclipse.persistence.antlr.jar org.eclipse.persistence.asm.jar org.eclipse.persistence.core.jar /opt/glassfish4/glassfish/modules/
COPY org.eclipse.persistence.dbws.jar org.eclipse.persistence.jpa.jar org.eclipse.persistence.jpa.jpql.jar /opt/glassfish4/glassfish/modules/
COPY org.eclipse.persistence.jpa.modelgen.processor.jar org.eclipse.persistence.moxy.jar org.eclipse.persistence.oracle.jar /opt/glassfish4/glassfish/modules/
COPY commons-logging-1.1.3.jar dol.jar /opt/glassfish4/glassfish/modules/
COPY postgresql-9.4-1206-jdbc42.jar log4j-1.2.16.jar commons-validator-1.4.0.jar commons-logging-1.1.3.jar jakarta-oro-2.0.8.jar /opt/lib/
