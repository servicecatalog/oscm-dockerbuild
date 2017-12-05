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

	/usr/bin/touch /root/.pgpass
	/usr/bin/chmod 600 /root/.pgpass
	echo "$1:$2:postgres:$DB_SUPERUSER:$DB_SUPERPWD" > /root/.pgpass
	export PGPASSFILE=/root/.pgpass
    until /usr/bin/psql -h $1 -p $2 -U $DB_SUPERUSER -l >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
}

# Generate property files for CORE from environment
function genPropertyFilesCORE {
    mkdir /opt/sqlscripts
	/usr/bin/envsubst < /opt/templates/init.sql.core.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.core.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings.properties.core.template > /opt/properties/configsettings.properties
	/usr/bin/envsubst < /opt/templates/sso.properties.core.template > /opt/properties/sso.properties
}

# Generate property files for JMS from environment
function genPropertyFilesJMS {
    mkdir /opt/sqlscripts
	/usr/bin/envsubst < /opt/templates/init.sql.jms.template > /opt/sqlscripts/init.sql
}

# Generate property files for APP from environment
function genPropertyFilesAPP {
    mkdir /opt/sqlscripts
	/usr/bin/envsubst < /opt/templates/init.sql.app.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.app.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings.properties.app.template > /opt/properties/configsettings.properties
}

# Generate property files for APP Controller from environment
function genPropertyFilesAPPController {
    mkdir /opt/sqlscripts
    /usr/bin/envsubst < /opt/templates/init.sql.app.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.app.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings_controller.properties.app.template > /opt/properties/configsettings.properties
}


# CORE
if [ $TARGET == "CORE" ]; then
	# Generate property files from environment
	genPropertyFilesCORE
	
	# Wait for database server to become ready
	waitForDB $DB_HOST_CORE $DB_PORT_CORE
	
	# Initialize CORE DB
	if [ $SOURCE == "INIT" ]; then
		# Create databases, schemas, users and roles
		psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/init.sql
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
            psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_GLOBALS
        fi
		psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqldump/$SQL_DUMP_BSS
	fi
	
	# Initialize and update data
	#java -cp "/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
	#	/opt/properties/db.properties /opt/sqlscripts/core
	tar -xf /opt/flyway.tar.gz -C /opt/
	cp /opt/lib/* /opt/flyway-4.2.0/jars/
	# Update properties
	/opt/flyway-4.2.0/flyway migrate -user=$DB_USER_CORE -schemas=${DB_NAME_CORE} -password=$DB_PWD_CORE -locations=classpath:/org/oscm/propertyimport,classpath:/sql,classpath:/org/oscm/dbtask -url=jdbc:postgresql://${DB_HOST_CORE}:${DB_PORT_CORE}/${DB_NAME_CORE}

	
	# Import SSO properties (only if AUTH_MODE is SAML_SP)
	#java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.ssopropertyimport.SSOPropertyImport org.postgresql.Driver \
		#"jdbc:postgresql://${DB_HOST_CORE}:${DB_PORT_CORE}/${DB_NAME_CORE}" $DB_USER_CORE $DB_PWD_CORE \
		#/opt/properties/configsettings.properties /opt/properties/sso.properties
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
	#java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
		#/opt/properties/db.properties /opt/sqlscripts/app
   
    # Update properties
	#java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver \
		#"jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" $DB_USER_APP $DB_PWD_APP \
		#/opt/properties/configsettings.properties $OVERWRITE

	tar -xf /opt/flyway.tar.gz -C /opt/
	cp /opt/lib/* /opt/flyway-4.2.0/jars/
	/opt/flyway-4.2.0/flyway migrate -user=$DB_USER_APP -schemas=${$DB_PWD_APP} -password=$DB_PWD_CORE -locations=classpath:/org/oscm/propertyimport,classpath:/sql,classpath:/org/oscm/dbtask -url=jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}
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
	#java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
	#	/opt/properties/db.properties /opt/sqlscripts/app
	
	# Import controller properties        
	#java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver \
	#	"jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" $DB_USER_APP $DB_PWD_APP \
	#	/opt/properties/configsettings.properties $OVERWRITE $CONTROLLER_ID
fi

# Check if specific db is ready
function checkDB {
	export PGPASSWORD=$DB_SUPERPWD
    until /usr/bin/psql -h $1 -p $2 -U $DB_SUPERUSER $3 >/dev/null 2>&1; do echo "Database $3 not ready - waiting..."; sleep 3s; done
	echo "Database $3 ready ..."
}

#SAMPLE DATA
if [ $TARGET == "SAMPLE_DATA" ]; then
    
    if [ -f /opt/sqlscripts/sample-data/core/sample.sql ]; then
    	checkDB $DB_HOST_CORE $DB_PORT_CORE $DB_NAME_CORE
		psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/sample-data/core/sample.sql $DB_NAME_CORE
	else
		echo "No sample core data found ..."
	fi	
	
	if [ -f /opt/sqlscripts/sample-data/app/sample.sql ]; then
    	checkDB $DB_HOST_APP $DB_PORT_APP $DB_NAME_APP
		psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/sample-data/app/sample.sql $DB_NAME_APP
	else
		echo "No sample app data found ..."
	fi
fi	
