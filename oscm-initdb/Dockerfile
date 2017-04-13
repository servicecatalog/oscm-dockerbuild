FROM oscm-gf

RUN mkdir -p /opt/sqlscripts/bes && \
    mkdir -p /opt/sqlscripts/app && \
	mkdir /opt/lib
  
COPY db.properties.jms /properties/jms/db.properties
COPY sqlscripts/bes/*.sql /opt/sqlscripts/bes/
COPY sqlscripts/app/*.sql /opt/sqlscripts/app/
COPY oscm-devruntime.jar /opt/
COPY oscm-common.jar /opt/lib
COPY log4j-1.2.16.jar /opt/lib
COPY postgresql-9.1-903.jdbc4.jar /opt/lib
COPY oscm-extsvc-internal.jar /opt/lib

COPY start.sh /opt/
RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]
