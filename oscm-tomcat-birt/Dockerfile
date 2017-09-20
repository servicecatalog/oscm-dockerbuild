FROM tomcat:8.5

COPY start.sh /opt/start.sh

RUN wget http://ftp.fau.de/eclipse/birt/downloads/drops/R-R1-4_5_0-201506092134/birt-runtime-4.5.0-20150609.zip -O /tmp/birt-runtime.zip && \
    wget https://github.com/servicecatalog/development/releases/download/v17.3.0/oscm-reports.zip -O /tmp/oscm-reports.zip && \
    mkdir /tmp/birt && \
    unzip /tmp/birt-runtime.zip -d /tmp/birt && \
    find /tmp/birt -type f -name birt.war -exec cp {} /usr/local/tomcat/webapps \; && \
    catalina.sh start && \
    sleep 5 && \
    catalina.sh stop && \
    unzip /tmp/oscm-reports.zip -d /usr/local/tomcat/webapps/birt && \
    rm /tmp/birt-runtime.zip && \
    rm /tmp/oscm-reports.zip && \
    rm -rf /tmp/birt && \
    chmod +x /opt/start.sh

#CMD ["catalina.sh", "run"]
CMD ["/opt/start.sh"]
