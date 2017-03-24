#!/bin/bash

java -jar /opt/oscm-devruntime.jar org.oscm.setup.DatabaseUpgradeHandler \
     /opt/glassfish3/glassfish/domains/bes-domain/conf/db.properties \
	 /opt/sqlscripts/
	 
/opt/glassfish3/glassfish/bin/asadmin start-domain master-indexer-domain
/opt/glassfish3/glassfish/bin/asadmin start-domain bes-domain

wait