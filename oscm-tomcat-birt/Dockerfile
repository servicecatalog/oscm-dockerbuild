FROM tomcat:8.5

RUN wget http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/R-R1-4_2_2-201302161152/birt-runtime-4_2_2.zip -O /tmp/birt-runtime-4_2_2.zip && \
    wget https://github.com/servicecatalog/development/releases/download/v16.1_Fix7/oscm-reports.zip -O /tmp/oscm-reports.zip && \
    mkdir /tmp/birt && \
    unzip /tmp/birt-runtime-4_2_2.zip -d /tmp/birt && \
    cp /tmp/birt/birt-runtime-4_2_2/birt.war /usr/local/tomcat/webapps && \
    mkdir /usr/local/tomcat/webapps/birt && \
    unzip /tmp/oscm-reports.zip -d /usr/local/tomcat/webapps/birt && \
    rm /tmp/birt-runtime-4_2_2.zip && \
    rm /tmp/oscm-reports.zip && \
    rm -rf /tmp/birt && \
    rm -rf /usr/local/tomcat/webapps/examples && \
    rm -rf /usr/local/tomcat/webapps/host-manager && \
    rm -rf /usr/local/tomcat/webapps/manager && \
    rm -rf /usr/local/tomcat/webapps/docs

CMD ["catalina.sh", "run"]

