 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM oscm-centos-based

ENV HOST_FQDN=localhost

COPY start.sh deploy.sh ssl.key ssl.crt /opt/
COPY ssl.crt /import/certs/
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors
COPY resources/server.xml /etc/tomcat/
COPY resources/context.xml /etc/tomcat/context.xml
COPY resources/logging.properties /etc/tomcat/logging.properties

RUN chmod +x /opt/deploy.sh && \
    chmod +x /opt/start.sh && \
    export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y \
        vim \
        tomcat && \
    yum clean all  && \
    sed -i 's|^JAVA_HOME=.*|JAVA_HOME="/usr/lib/jvm/jre"|g' /etc/tomcat/tomcat.conf && \

    wget --quiet https://github.com/servicecatalog/oscm/releases/download/v19.1/birt.war -O /tmp/birt.war && \
    wget --quiet https://github.com/servicecatalog/development/releases/download/v17.4.0/oscm-reports.zip -O /tmp/oscm-reports.zip && \
    cp /tmp/birt.war /var/lib/tomcat/webapps
    /opt/deploy.sh && \
    unzip /tmp/oscm-reports.zip -d /var/lib/tomcat/webapps/birt && \
    chown -R tomcat: /var/lib/tomcat/webapps/birt && \
    rm /tmp/oscm-reports.zip && \
    rm -f /tmp/birt.war

CMD ["/opt/start.sh"]
