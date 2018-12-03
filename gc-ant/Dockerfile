FROM oscm-sles-based

ENV JAVA_HOME /usr/lib/jvm/java
ENV ANT_HOME /usr/share/ant
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY

RUN yum -y install \
    java-1.8.0-openjdk \
    java-1.8.0-openjdk-devel \
    ant \
    ant-contrib \
    apache-ivy

ENTRYPOINT ["ant"]