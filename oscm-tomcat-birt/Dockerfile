FROM tomcat:8.5

RUN wget http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/R-R1-4_2_2-201302161152/birt-runtime-4_2_2.zip -O /tmp/birt-runtime.zip && \
#RUN wget http://ftp.fau.de/eclipse/birt/downloads/drops/R-R1-4_5_0-201506092134/birt-runtime-4.5.0-20150609.zip -O /tmp/birt-runtime.zip && \
    wget https://github.com/servicecatalog/development/releases/download/v16.1_Fix7/oscm-reports.zip -O /tmp/oscm-reports.zip && \
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
    rm -rf /usr/local/tomcat/webapps/examples && \
    rm -rf /usr/local/tomcat/webapps/host-manager && \
    rm -rf /usr/local/tomcat/webapps/manager && \
    rm -rf /usr/local/tomcat/webapps/docs

CMD ["catalina.sh", "run"]

