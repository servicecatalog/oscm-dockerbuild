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

# HELPER: Wait for database server to become ready
function waitForDB {
	/usr/bin/touch /root/.pgpass
	/usr/bin/chmod 600 /root/.pgpass
	echo "$1:$2:postgres:$DB_SUPERUSER:$DB_SUPERPWD" > /root/.pgpass
	export PGPASSFILE=/root/.pgpass
    until /usr/bin/psql -h $1 -p $2 -U $DB_SUPERUSER -l >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
}

# HELPER: Generate property files for CORE from environment
function genPropertyFilesCORE {
	/usr/bin/envsubst < /opt/templates/init.sql.core.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.core.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings.properties.core.template > /opt/properties/configsettings.properties
    /usr/bin/envsubst < /opt/templates/sso.properties.core.template > /opt/properties/sso.properties
}

# HELPER: Generate sql file for update users
function genSQLUpdateUser {
	/usr/bin/envsubst < /opt/templates/platformusers.sql.administrator.template > /opt/sqlscripts/core/administrator.sql
	/usr/bin/envsubst < /opt/templates/platformusers.sql.customer.template > /opt/sqlscripts/core/customer.sql
	/usr/bin/envsubst < /opt/templates/platformusers.sql.supplier.template > /opt/sqlscripts/core/supplier.sql
}	

# HELPER: Generate property files for JMS from environment
function genPropertyFilesJMS {
	/usr/bin/envsubst < /opt/templates/init.sql.jms.template > /opt/sqlscripts/init.sql
}

# HELPER: Generate property files for APP from environment
function genPropertyFilesAPP {
	/usr/bin/envsubst < /opt/templates/init.sql.app.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.app.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings.properties.app.template > /opt/properties/configsettings.properties
}

# HELPER: Generate property files for APP Controller from environment
function genPropertyFilesAPPController {
    /usr/bin/envsubst < /opt/templates/init.sql.app.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.app.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/configsettings_controller.properties.app.template > /opt/properties/configsettings.properties
}

# HELPER: Generate property files for VMware Controller from environment
function genPropertyFilesVMwareController {
    /usr/bin/envsubst < /opt/templates/init.sql.vmware.template > /opt/sqlscripts/init.sql
    /usr/bin/envsubst < /opt/templates/db.properties.vmware.template > /opt/properties/db.properties
    /usr/bin/envsubst < /opt/templates/sample.sql.vmware.template > /opt/sqlscripts/vmware/sample.sql
}

# HELPER: Generate sample data files
function genSampleData {
    /usr/bin/envsubst < /opt/templates/sample.sql.core.template > /opt/sqlscripts/core/sample.sql
    /usr/bin/envsubst < /opt/templates/sample.sql.app.template > /opt/sqlscripts/app/sample.sql
}

# HELPER: Update db values related to HOST_FQDN setting
function updateHostFqdnValues {
	/usr/bin/envsubst < /opt/templates/hostfqdn.sql.core.template > /opt/sqlscripts/core/hostfqdn.sql
    /usr/bin/envsubst < /opt/templates/hostfqdn.sql.app.template > /opt/sqlscripts/app/hostfqdn.sql

    if [ ! -f /opt/sqlscripts/core/hostfqdn.sql ] || [ ! -f /opt/sqlscripts/app/hostfqdn.sql ]; then
		echo "No scripts for updating HOST_FQDN ..."
	else
		echo "$(date '+%Y-%m-%d %H:%M:%S') updating HOST_FQDN values"
		PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/hostfqdn.sql $DB_NAME_CORE
		PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/app/hostfqdn.sql $DB_NAME_APP
	fi
}

# Main script
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
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
		/opt/properties/db.properties /opt/sqlscripts/core

	# Update properties
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.propertyimport.PropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_CORE}:${DB_PORT_CORE}/${DB_NAME_CORE}" $DB_USER_CORE $DB_PWD_CORE \
		/opt/properties/configsettings.properties $OVERWRITE

	# Import SSO properties (only if AUTH_MODE is SAML_SP)
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.ssopropertyimport.SSOPropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_CORE}:${DB_PORT_CORE}/${DB_NAME_CORE}" $DB_USER_CORE $DB_PWD_CORE \
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

# VMware Controller
if [ $TARGET == "VMWARE" ]; then
	# Generate property files from environment
	genPropertyFilesVMwareController

	# Wait for database server to become ready
	waitForDB $DB_HOST_APP $DB_PORT_APP

	# Initialize APP DB
	if [ $SOURCE == "INIT" ]; then
		# Create databases, schemas, users and roles
		psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/init.sql
	fi

	# Initialize and update data
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
		/opt/properties/db.properties /opt/sqlscripts/vmware

	PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/vmware/sample.sql vmware
fi

# Sample data
if [ $TARGET == "SAMPLE_DATA" ]; then
	# Wait for databases to be reachable
    waitForDB $DB_HOST_CORE $DB_PORT_CORE
	waitForDB $DB_HOST_APP $DB_PORT_APP
	# Generate sample data and HOST_FQDN update SQL files
    genSampleData

	if [ ! -f /opt/sqlscripts/core/sample.sql ] || [ ! -f /opt/sqlscripts/app/sample.sql ]; then
		echo "No sample data found ..."
	else
		# Check whether data already exists in the database
		if [ ! $(PGPASSWORD=${DB_SUPERPWD} psql -t -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -d $DB_NAME_CORE -c "SELECT COUNT(*) FROM $DB_USER_CORE.organization;") -gt 1 ]; then
			# Import sample data to databases
			PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/sample.sql $DB_NAME_CORE
			PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/app/sample.sql $DB_NAME_APP

			# Update HOST_FQDN values
			updateHostFqdnValues
		else
			echo "$(date '+%Y-%m-%d %H:%M:%S') sample data not applicable"

			# Update HOST_FQDN values
			updateHostFqdnValues
		fi
	fi
fi

#Update the sampe users, if defined in the var.env template
genSQLUpdateUser
ADMIN_USER_ID = ${ADMIN_USER_ID}
CUSTOMER_USER_ID = ${CUSTOMER_USER_ID}
SUPPLIER_USER_ID = ${SUPPLIER_USER_ID}
if [ ! -z "$ADMIN_USER_ID"]; then
	PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/administrator.sql $DB_NAME_CORE 
fi	
if [ ! -z "$CUSTOMER_USER_ID"]; then
	PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/customer.sql $DB_NAME_CORE 
fi	
if [ ! -z "$SUPPLIER_USER_ID"]; then
	PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/supplier.sql $DB_NAME_CORE 
fi	

