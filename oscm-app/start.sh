#!/bin/bash

java -jar /opt/oscm-devruntime.jar org.oscm.setup.DatabaseUpgradeHandler \
     /opt/glassfish3/glassfish/domains/app-domain/conf/db.properties \
	 /opt/sqlscripts/
	 
/opt/glassfish3/glassfish/bin/asadmin start-domain --verbose app-domain

