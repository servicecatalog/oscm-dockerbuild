FROM oscm-sles-based

ENV JAVA_HOME /usr/lib/jvm/java
ENV ANT_HOME /usr/share/ant
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY

RUN yum update -y && \
    yum install -y \
    java-1.8.0-openjdk \
    java-1.8.0-openjdk-devel 

RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.6-bin.zip -O /opt/ant.zip
RUN unzip /opt/ant.zip -d /opt/  
RUN wget https://repo1.maven.org/maven2/org/apache/ivy/ivy/2.4.0/ivy-2.4.0.jar  -O /opt/apache-ant-1.9.6/lib/ivy.jar

ENTRYPOINT ["/opt/apache-ant-1.9.6/bin/ant"]
