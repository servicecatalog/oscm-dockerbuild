FROM centos:7

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum -y update && \
    yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel unzip wget postgresql96 && \
    yum clean all && \
    wget http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip -O /tmp/glassfish.zip && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-156.jar -O /usr/lib/jvm/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib/jvm/jre/lib/security/java.security && \
    unzip /tmp/glassfish.zip -d /opt/ && \
	rm -rf /opt/glassfish3/glassfish/domains/domain1 && \
    rm /tmp/glassfish.zip
    

COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib/
COPY javax.faces.jar /opt/glassfish3/glassfish/modules/
COPY jboss-logging.jar /opt/glassfish3/glassfish/modules/
