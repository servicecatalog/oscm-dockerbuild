FROM oscm-sles-based

#COPY start.sh deploy.sh /opt/
COPY start.sh /opt/
COPY resources/server.xml /etc/tomcat/
#
#RUN chmod +x /opt/deploy.sh && \
#    chmod +x /opt/start.sh && \
#    export http_proxy=$HTTP_PROXY && \
#    export https_proxy=$HTTPS_PROXY && \
#    zypper in -y tomcat && \
#    zypper clean && \
#    wget http://ftp.fau.de/eclipse/birt/downloads/drops/R-R1-4_5_0-201506092134/birt-runtime-4.5.0-20150609.zip -O /tmp/birt-runtime.zip && \
#    wget https://github.com/servicecatalog/development/releases/download/v17.3.0/oscm-reports.zip -O /tmp/oscm-reports.zip && \
#    mkdir /tmp/birt && \
#    unzip /tmp/birt-runtime.zip -d /tmp/birt && \
#    find /tmp/birt -type f -name birt.war -exec cp {} /srv/tomcat/webapps \; && \
#    /opt/deploy.sh && \
#    unzip /tmp/oscm-reports.zip -d /srv/tomcat/webapps/birt && \
#    chown -R tomcat: /srv/tomcat/webapps/birt && \
#    rm /tmp/birt-runtime.zip && \
#    rm /tmp/oscm-reports.zip && \
#    rm -rf /tmp/birt
#
#CMD ["/opt/start.sh"]

RUN chmod +x /opt/start.sh && \
    export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    wget http://ftp.ps.pl/pub/apache/tomcat/tomcat-9/v9.0.1/bin/apache-tomcat-9.0.1.zip -O /tmp/tomcat-9.zip && \
    unzip /tmp/tomcat-9.zip -d /opt/tomcat-9 && \
    wget http://ftp.fau.de/eclipse/birt/downloads/drops/R-R1-4_5_0-201506092134/birt-runtime-4.5.0-20150609.zip -O /tmp/birt-runtime.zip && \
    wget https://github.com/servicecatalog/development/releases/download/v17.3.0/oscm-reports.zip -O /tmp/oscm-reports.zip && \
    mkdir /tmp/birt && \
    unzip /tmp/birt-runtime.zip -d /tmp/birt && \
    find /tmp/birt -type f -name birt.war -exec cp {} /opt/tomcat-9/apache-tomcat-9.0.1/webapps \; && \
#    /opt/deploy.sh && \
    unzip /tmp/oscm-reports.zip -d /opt/tomcat-9/apache-tomcat-9.0.1/webapps/birt && \
#    chown -R tomcat: /opt/tomcat-9/apache-tomcat-9.0.1/webapps/birt && \
    rm /tmp/birt-runtime.zip && \
    rm /tmp/oscm-reports.zip && \
    rm /tmp/tomcat-9.zip && \
    rm -rf /tmp/birt

CMD ["/opt/start.sh"]