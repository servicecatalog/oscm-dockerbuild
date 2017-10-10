FROM oscm-sles-based

COPY start.sh deploy.sh /opt/
COPY resources/server.xml /etc/tomcat/

RUN chmod +x /opt/start.sh && \
    export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper -n in gettext-runtime vim postgresql94 java-1_8_0-openjdk java-1_8_0-openjdk-devel && \
    zypper clean && \
    wget http://ftp.ps.pl/pub/apache/tomcat/tomcat-9/v9.0.1/bin/apache-tomcat-9.0.1.zip -O /tmp/tomcat-9.zip && \
    unzip /tmp/tomcat-9.zip -d /opt/tomcat-9 && \
    wget http://ftp.fau.de/eclipse/birt/downloads/drops/R-R1-4_5_0-201506092134/birt-runtime-4.5.0-20150609.zip -O /tmp/birt-runtime.zip && \
    wget https://github.com/servicecatalog/development/releases/download/v17.3.0/oscm-reports.zip -O /tmp/oscm-reports.zip && \
    mkdir /tmp/birt && \
    unzip /tmp/birt-runtime.zip -d /tmp/birt && \
    cp /tmp/birt/birt-runtime-4_5_0/birt.war /opt/tomcat-9/apache-tomcat-9.0.1/webapps && \
    unzip /opt/tomcat-9/apache-tomcat-9.0.1/webapps/birt.war -d /opt/tomcat-9/apache-tomcat-9.0.1/webapps/birt && \
    unzip /tmp/oscm-reports.zip -d /opt/tomcat-9/apache-tomcat-9.0.1/webapps/birt && \
    chmod -R 755 /opt/tomcat-9/ && \
    groupadd tomcat && \
    useradd -G tomcat tomcat && \
    rm /tmp/birt-runtime.zip && \
    rm /tmp/oscm-reports.zip && \
    rm /tmp/tomcat-9.zip && \
    rm -rf /tmp/birt

CMD ["/opt/start.sh"]