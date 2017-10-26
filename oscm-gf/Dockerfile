FROM oscm-sles-based

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper -n in gettext-runtime vim postgresql94 java-1_8_0-openjdk java-1_8_0-openjdk-devel && \
    zypper clean && \
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi && \
    wget http://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/7.0.3/apache-tomee-7.0.3-plume.tar.gz -O /tmp/apache-tomee.tar.gz && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-157.jar -O /usr/lib64/jvm/java-1.8.0-openjdk/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib64/jvm/java-1.8.0-openjdk/jre/lib/security/java.security && \
    mkdir /opt/apache-tomee && \
    tar --strip-components=1 -C /opt/apache-tomee -zxf /tmp/apache-tomee.tar.gz && \
    rm /tmp/apache-tomee.tar.gz
