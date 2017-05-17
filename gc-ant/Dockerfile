FROM ubuntu

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV ANT_HOME /usr/share/ant
ENV IVY_HOME /usr/share/java

RUN apt-get update && \
    apt-get update && apt-get -y install hostname openjdk-8-jre openjdk-8-jdk ant ant-optional ivy && \
    cp $IVY_HOME/ivy.jar $ANT_HOME/lib/

ENTRYPOINT ["ant"]
