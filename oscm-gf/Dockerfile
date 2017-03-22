FROM centos7

ENV GLASSFISH_HOME=/opt/glassfish3

RUN yum -y install java-1.7.0-openjdk unzip

COPY glassfish-3.1.2.2.zip /tmp/
RUN unzip glassfish-3.1.2.2.zip -d /opt/

COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib/

RUN rm -rf /opt/glassfish3/glassfish/domains/domain1
