 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM oscm-centos-based

ENV JAVA_HOME /usr/lib/jvm/java
ENV ANT_HOME /usr/share/ant
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY

ARG SASS_VERSION='1.26.11'
ARG SASS_BINARY="dart-sass-${SASS_VERSION}-linux-x64.tar.gz"
ARG SASS_PATH=/usr/local/dart-sass

RUN yum update -y && \
    yum install -y \
        java-1.8.0-openjdk \
        java-1.8.0-openjdk-devel \
        git \
    yum clean all && \
    wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.6-bin.zip -O /opt/ant.zip && \
    unzip /opt/ant.zip -d /opt/ && \
    wget https://repo1.maven.org/maven2/org/apache/ivy/ivy/2.4.0/ivy-2.4.0.jar  -O /opt/apache-ant-1.9.6/lib/ivy.jar && \
    wget "https://github.com/sass/dart-sass/releases/download/${SASS_VERSION}/${SASS_BINARY}" -O /tmp/"${SASS_BINARY}" && \
    tar -C /usr/local -xzf /tmp/"${SASS_BINARY}"

ENV PATH "$PATH:${SASS_PATH}"

ENTRYPOINT ["/opt/apache-ant-1.9.6/bin/ant"]
