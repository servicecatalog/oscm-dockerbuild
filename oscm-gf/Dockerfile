FROM oscm-centos-based

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y \
        vim \
        postgresql \
        java-1.8.0-openjdk \
        java-1.8.0-openjdk-devel \
        tar && \
    yum clean all && \
    wget http://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/7.0.3/apache-tomee-7.0.3-plume.tar.gz -O /tmp/apache-tomee.tar.gz && \
    wget https://www.bouncycastle.org/download/bcprov-jdk15on-157.jar -O /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/ext/bcprov.jar && \
    echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/java.security && \
    mkdir /opt/apache-tomee && \
    tar --strip-components=1 -C /opt/apache-tomee -zxf /tmp/apache-tomee.tar.gz && \
    rm /tmp/apache-tomee.tar.gz

COPY resources/logging.properties /opt/apache-tomee/conf/logging.properties

