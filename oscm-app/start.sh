#!/bin/bash

java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
     /opt/glassfish3/glassfish/domains/app-domain/config/db.properties \
	 /opt/sqlscripts/
	 
/opt/glassfish3/glassfish/bin/asadmin start-domain --verbose app-domain

