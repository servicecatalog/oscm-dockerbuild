#!/bin/bash

# Mandatory files (mount these) for DB import from SQL files (SOURCE=DUMP)
# SQL_DUMP_GLOBALS="/opt/sqldump/globals.sql": Dump of the globals (DBs, Schemas, Roles, ...)
# SQL_DUMP_BSS="/opt/sqldump/bss.sql": Dump of the bss database
# SQL_DUMP_BSSJMS="/opt/sqldump/bssjms.sql": Dump of the jms database
# SQL_DUMP_BSSAPP="/opt/sqldump/bssapp.sql": Dump of the app database


# Exit on error
trap 'echo ERROR at line $LINENO; exit' ERR

export PGCONNECT_TIMEOUT=2

mkdir -p /opt/properties/

# Wait for database server to become ready
function waitForDB {
    until /usr/bin/psql -h $1 -p $2 -U postgres -l >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
}

# Generate property files for BES from environment
function genPropertyFilesBES {   
	/usr/bin/envsubst < /opt/templates/init.sql.bes.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.bes.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings.properties.bes.template > /opt/properties/configsettings.properties
	/usr/bin/envsubst < /opt/templates/sso.properties.bes.template > /opt/properties/sso.properties
}

# Generate property files for JMS from environment
function genPropertyFilesJMS {
	/usr/bin/envsubst < /opt/templates/init.sql.jms.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/config.properties.bes.template > /opt/glassfish4/glassfish/domains/bes-domain/imq/instances/imqbroker/props/config.properties
    /usr/bin/envsubst < /opt/templates/config.properties.mi.template > /opt/glassfish4/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props/config.properties
}

# Generate property files for APP from environment
function genPropertyFilesAPP {
	/usr/bin/envsubst < /opt/templates/init.sql.app.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.app.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings.properties.app.template > /opt/properties/configsettings.properties
}

# Generate property files for APP Controller from environment
function genPropertyFilesAPPController {
    /usr/bin/envsubst < /opt/templates/init.sql.app.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.app.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings_controller.properties.app.template > /opt/properties/configsettings.properties
}


# BES
if [ $TARGET == "BES" ]; then
	# Generate property files from environment
	genPropertyFilesBES
	
	# Wait for database server to become ready
	waitForDB $DB_HOST_BES $DB_PORT_BES
	
	# Initialize BES DB
	if [ $SOURCE == "INIT" ]; then
		# Create databases, schemas, users and roles
		psql -h $DB_HOST_BES -p $DB_PORT_BES -U $DB_SUPERUSER -f /opt/sqlscripts/init.sql
	fi
	
	# Import SQL dumps
	if [ $SOURCE == "DUMP" ]; then
		if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_GLOBALS.gz > /opt/sqldump/$SQL_DUMP_GLOBALS
		fi
		if [ -f /opt/sqldump/$SQL_DUMP_BSS.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_BSS.gz > /opt/sqldump/$SQL_DUMP_BSS
		fi
        if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS ]; then
            psql -h $DB_HOST_BES -p $DB_PORT_BES -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_GLOBALS
        fi
		psql -h $DB_HOST_BES -p $DB_PORT_BES -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_BSS
	fi
	
	# Initialize and update data
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
		/opt/properties/db.properties /opt/sqlscripts/bes
	
	# Update properties
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.propertyimport.PropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" $DB_USER_BES $DB_PWD_BES \
		/opt/properties/configsettings.properties $OVERWRITE
	
	# Import SSO properties (only if AUTH_MODE is SAML_SP)
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.ssopropertyimport.SSOPropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" $DB_USER_BES $DB_PWD_BES \
		/opt/properties/configsettings.properties /opt/properties/sso.properties        
fi

# JMS
if [ $TARGET == "JMS" ]; then
	# Generate property files from environment
	genPropertyFilesJMS
	
	# Wait for database server to become ready
	waitForDB $DB_HOST_JMS $DB_PORT_JMS
	
	# Initialize JMS DB
	if [ $SOURCE == "INIT" ]; then
		# Create databases, schemas, users and roles
		psql -h $DB_HOST_JMS -p $DB_PORT_JMS -U $DB_SUPERUSER -f /opt/sqlscripts/init.sql
		
		# Initialize data
		/opt/glassfish4/mq/bin/imqdbmgr recreate tbl -varhome /opt/glassfish4/glassfish/domains/master-indexer-domain/imq -javahome /usr/lib/jvm/java
        /opt/glassfish4/mq/bin/imqdbmgr recreate tbl -varhome /opt/glassfish4/glassfish/domains/bes-domain/imq -javahome /usr/lib/jvm/java
	fi
	
	# Import SQL dumps
	if [ $SOURCE == "DUMP" ]; then
		if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_GLOBALS.gz > /opt/sqldump/$SQL_DUMP_GLOBALS
		fi
		if [ -f /opt/sqldump/$SQL_DUMP_BSSJMS.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_BSSJMS.gz > /opt/sqldump/$SQL_DUMP_BSSJMS
		fi
        if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS ]; then
            psql -h $DB_HOST_JMS -p $DB_PORT_JMS -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_GLOBALS
        fi
		psql -h $DB_HOST_JMS -p $DB_PORT_JMS -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_BSSJMS
	fi	
fi

# APP
if [ $TARGET == "APP" ]; then
	# Generate property files from environment
	genPropertyFilesAPP
	
	# Wait for database server to become ready
	waitForDB $DB_HOST_APP $DB_PORT_APP
	
	# Initialize APP DB
	if [ $SOURCE == "INIT" ]; then    
		# Create databases, schemas, users and roles
		psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/init.sql
	fi
	
	# Import SQL dumps
	if [ $SOURCE == "DUMP" ]; then
		if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_GLOBALS.gz > /opt/sqldump/$SQL_DUMP_GLOBALS
		fi
		if [ -f /opt/sqldump/$SQL_DUMP_BSSAPP.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_BSSAPP.gz > /opt/sqldump/$SQL_DUMP_BSSAPP
		fi
        if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS ]; then
            psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_GLOBALS
        fi
		psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_BSSAPP
	fi
	
	# Initialize and update data
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
		/opt/properties/db.properties /opt/sqlscripts/app
   
    # Update properties
	java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" $DB_USER_APP $DB_PWD_APP \
		/opt/properties/configsettings.properties $OVERWRITE
fi

# APP Controller
if [ $TARGET == "CONTROLLER" ]; then
	# Generate property files from environment
	genPropertyFilesAPPController
	
	# Wait for database server to become ready
	waitForDB $DB_HOST_APP $DB_PORT_APP
	
	# Initialize APP DB
	if [ $SOURCE == "INIT" ]; then    
		# Create databases, schemas, users and roles
		psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/init.sql
	fi
	
	# Import SQL dumps
	if [ $SOURCE == "DUMP" ]; then
		if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_GLOBALS.gz > /opt/sqldump/$SQL_DUMP_GLOBALS
		fi
		if [ -f /opt/sqldump/$SQL_DUMP_BSSAPP.gz ]; then
			gunzip -c /opt/sqldump/$SQL_DUMP_BSSAPP.gz > /opt/sqldump/$SQL_DUMP_BSSAPP
		fi
        if [ -f /opt/sqldump/$SQL_DUMP_GLOBALS ]; then
            psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_GLOBALS
        fi
		psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_BSSAPP
	fi
	
	# Initialize and update data
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
		/opt/properties/db.properties /opt/sqlscripts/app
	
	# Import controller properties        
	java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" $DB_USER_APP $DB_PWD_APP \
		/opt/properties/configsettings.properties $OVERWRITE $CONTROLLER_ID        
fi
