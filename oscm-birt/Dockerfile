FROM oscm-sles-based

ENV HOST_FQDN=localhost

COPY start.sh deploy.sh ssl.key ssl.crt /opt/
COPY ssl.crt /import/certs/
COPY ssl.crt /usr/share/pki/trust/anchors
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
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi && \
    sed -i 's|^JAVA_HOME=.*|JAVA_HOME="/usr/lib64/jvm/jre"|g' /etc/tomcat/tomcat.conf && \
    wget --quiet http://ftp.fau.de/eclipse/birt/downloads/drops/R-R1-4_5_0-201506092134/birt-runtime-4.5.0-20150609.zip -O /tmp/birt-runtime.zip && \
    wget --quiet https://github.com/servicecatalog/oscm-report-templates/releases/download/1.0/oscm-reports.zip -O /tmp/oscm-reports.zip && \
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
