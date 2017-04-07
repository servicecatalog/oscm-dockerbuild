FROM tomcat:8.5

COPY birt-runtime-4_2_2.zip /tmp

RUN wget http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/R-R1-4_2_2-201302161152/birt-runtime-4_2_2.zip -O /tmp/birt-runtime-4_2_2.zip && \
    mkdir /tmp/birt && \
    unzip /tmp/birt-runtime-4_2_2.zip -d /tmp/birt && \
    cp /tmp/birt/birt-runtime-4_2_2/birt.war /usr/local/tomcat/webapps && \
    rm /tmp/birt-runtime-4_2_2.zip && \
    rm -rf /tmp/birt && \
    rm -rf /usr/local/tomcat/webapps/examples && \
    rm -rf /usr/local/tomcat/webapps/host-manager && \
    rm -rf /usr/local/tomcat/webapps/manager && \
    rm -rf /usr/local/tomcat/webapps/docs

CMD ["catalina.sh", "run"]

