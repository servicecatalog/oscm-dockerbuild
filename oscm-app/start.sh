#!/bin/bash
if [ -f /opt/glassfish3/glassfish/domains/app-domain/config/db.properties ]; then
    export DB_HOST=$(sed -n -e 's|^db.host=\(.*\)$|\1|gp' /opt/glassfish3/glassfish/domains/app-domain/config/db.properties)
    export DB_USER=$(sed -n -e 's|^db.user=\(.*\)$|\1|gp' /opt/glassfish3/glassfish/domains/app-domain/config/db.properties)
    export PGPASSWORD=$(sed -n -e 's|^db.pwd=\(.*\)$|\1|gp' /opt/glassfish3/glassfish/domains/app-domain/config/db.properties)
    export PGCONNECT_TIMEOUT=2
    until psql -h $DB_HOST -l -U $DB_USER -q >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
fi

java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
     /opt/glassfish3/glassfish/domains/app-domain/config/db.properties \
	 /opt/sqlscripts/

/opt/glassfish3/glassfish/bin/asadmin start-domain --verbose app-domain
