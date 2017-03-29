FROM centos:7

RUN yum -y install java-1.7.0-openjdk unzip wget && \
    wget http://download.java.net/glassfish/3.1.2/release/glassfish-3.1.2.zip -O /tmp/glassfish.zip && \
    unzip /tmp/glassfish.zip -d /opt/ && \
	rm -rf /opt/glassfish3/glassfish/domains/domain1 && \
	rm /tmp/glassfish.zip

COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib/
