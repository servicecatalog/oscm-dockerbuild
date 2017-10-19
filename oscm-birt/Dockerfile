FROM oscm-sles-based

COPY start.sh deploy.sh ssl.key ssl.crt /opt/
COPY ssl.crt /import/certs/
COPY resources/server.xml /etc/tomcat/
COPY resources/catalina.properties /etc/tomcat/catalina.properties
COPY resources/context.xml /etc/tomcat/context.xml

RUN chmod +x /opt/deploy.sh && \
    chmod +x /opt/start.sh && \
    export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper in -y tomcat && \
    zypper -n in vim && \
    zypper clean && \
    wget http://ftp.fau.de/eclipse/birt/downloads/drops/R-R1-4_5_0-201506092134/birt-runtime-4.5.0-20150609.zip -O /tmp/birt-runtime.zip && \
    wget https://github.com/servicecatalog/development/releases/download/v17.3.0/oscm-reports.zip -O /tmp/oscm-reports.zip && \
    mkdir /tmp/birt && \
    unzip /tmp/birt-runtime.zip -d /tmp/birt && \
    find /tmp/birt -type f -name birt.war -exec cp {} /srv/tomcat/webapps \; && \
    /opt/deploy.sh && \
    unzip /tmp/oscm-reports.zip -d /srv/tomcat/webapps/birt && \
    chown -R tomcat: /srv/tomcat/webapps/birt && \
    rm /tmp/birt-runtime.zip && \
    rm /tmp/oscm-reports.zip && \
    rm -rf /tmp/birt
    
CMD ["/opt/start.sh"]
