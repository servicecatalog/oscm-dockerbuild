FROM ubuntu

ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV ANT_HOME /usr/share/ant
ENV IVY_HOME /usr/share/java

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && apt-get -y install hostname openjdk-7-jre openjdk-7-jdk ant ant-optional ivy && \
    cp $IVY_HOME/ivy.jar $ANT_HOME/lib/

ENTRYPOINT ["ant"]
