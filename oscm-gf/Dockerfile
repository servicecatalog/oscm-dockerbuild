FROM centos:7

RUN yum -y install java-1.7.0-openjdk unzip && \
    wget http://download.java.net/glassfish/3.1.2/release/glassfish-3.1.2.zip && \
    unzip glassfish-3.1.2.2.zip -d /opt/ && \
	rm -rf /opt/glassfish3/glassfish/domains/domain1

COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib/
