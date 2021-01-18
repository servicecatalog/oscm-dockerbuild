#!/bin/bash

 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

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
    /usr/bin/envsubst < /opt/templates/configsettings_controller.properties.app.template > /opt/properties/configsettings.properties
}

# HELPER: Generate property files for approval from environment
function genPropertyFilesAPPROVAL {
	/usr/bin/envsubst < /opt/templates/init.sql.approval.template > /opt/sqlscripts/init.sql
	/usr/bin/envsubst < /opt/templates/db.properties.approval.template > /opt/properties/db.properties
	/usr/bin/envsubst < /opt/templates/configsettings_controller.properties.app.template > /opt/properties/configsettings.properties
}

# HELPER: Generate sample data files
function genSampleData {
    /usr/bin/envsubst < /opt/templates/sample.sql.core.template > /opt/sqlscripts/core/sample.sql
    /usr/bin/envsubst < /opt/templates/sample.sql.app.template > /opt/sqlscripts/app/sample.sql
}

# HELPER: Generate sql file for update users
function genSQLUpdateUser {
	/usr/bin/envsubst < /opt/templates/platformusers.sql.customer.template > /opt/sqlscripts/core/customer.sql
	/usr/bin/envsubst < /opt/templates/platformusers.sql.supplier.template > /opt/sqlscripts/core/supplier.sql
	/usr/bin/envsubst < /opt/templates/platformusers.sql.reseller.template > /opt/sqlscripts/core/reseller.sql
}	
# HELPER: Generate sql file for update admin
function genSQLUpdateAdmin {
	/usr/bin/envsubst < /opt/templates/platformusers.sql.administrator.template > /opt/sqlscripts/core/administrator.sql
}	

# HELPER: Updates the DB the configurationsettings
function updateProperties {
		java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" $DB_USER_APP $DB_PWD_APP \
		/opt/properties/configsettings.properties $1 $2
}

# HELPER: Initialize APP Data
function initializeAppData {
	if [ $SOURCE == "INIT" ]; then
		# Create databases, schemas, users and roles
		psql -h $DB_HOST_APP -p $DB_PORT_APP -U $DB_SUPERUSER -f /opt/sqlscripts/init.sql
	fi
}
# HELPER: Initialize and update data
function initializeAndUpdateData {
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler \
	/opt/properties/db.properties $1
}

# Main script
# CORE
if [ $TARGET == "CORE" ]; then

	# Enable automatic exporting of variables
	set -a
	# Read configuration files
	source /target/.env
	# Disable automatic exporting of variables
	set +a
	echo "HOST_FQDN="${HOST_FQDN}
	echo "IMAGE_DB="${IMAGE_DB}

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
	initializeAndUpdateData /opt/sqlscripts/core

	# Update properties
	java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.propertyimport.PropertyImport org.postgresql.Driver \
		"jdbc:postgresql://${DB_HOST_CORE}:${DB_PORT_CORE}/${DB_NAME_CORE}" $DB_USER_CORE $DB_PWD_CORE \
		/opt/properties/configsettings.properties $OVERWRITE

	#Update the sampe users, if defined in the var.env template
	if [ ! -z "${ADMIN_USER_ID}" ]; then
		genSQLUpdateAdmin
		PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/administrator.sql $DB_NAME_CORE
	fi
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
	initializeAppData

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
	initializeAndUpdateData /opt/sqlscripts/app

    # Update properties
	updateProperties $OVERWRITE
fi

# APP Controller
if [ $TARGET == "CONTROLLER" ]; then
	# Generate property files from environment
	genPropertyFilesAPPController

	# Wait for database server to become ready
	waitForDB $DB_HOST_APP $DB_PORT_APP

	# Initialize APP DB
	initializeAppData

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
	initializeAndUpdateData /opt/sqlscripts/app

	# Import controller properties
	updateProperties $OVERWRITE $CONTROLLER_ID
		
fi

# VMware Controller
if [ $TARGET == "VMWARE" ]; then
	# Generate property files from environment
	genPropertyFilesVMwareController

	# Wait for database server to become ready
	waitForDB $DB_HOST_APP $DB_PORT_APP

	# Initialize APP DB
	initializeAppData

	# Initialize and update data
	initializeAndUpdateData /opt/sqlscripts/vmware
		
	# Import controller properties
	updateProperties $OVERWRITE $CONTROLLER_ID
fi

# Approval Tool
if [ $TARGET == "APPROVAL" ]; then
	# Generate property files from environment
	genPropertyFilesAPPROVAL

	# Wait for database server to become ready
	waitForDB $DB_HOST_APP $DB_PORT_APP

	# Initialize APP DB
	initializeAppData

	# Initialize and update data
	initializeAndUpdateData /opt/sqlscripts/approval
		
	# Import controller properties
	updateProperties $OVERWRITE $CONTROLLER_ID
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
			
			#Update the sample users, if defined in the var.env template
			genSQLUpdateUser
			if [ ! -z "${CUSTOMER_USER_ID}" ]; then
				PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/customer.sql $DB_NAME_CORE 
			fi	
			if [ ! -z "${SUPPLIER_USER_ID}" ]; then
				PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/supplier.sql $DB_NAME_CORE 
			fi	
			if [ ! -z "${RESELLER_USER_ID}" ]; then
				PGPASSWORD=${DB_SUPERPWD} psql -h $DB_HOST_CORE -p $DB_PORT_CORE -U $DB_SUPERUSER -f /opt/sqlscripts/core/reseller.sql $DB_NAME_CORE 
			fi	
		else
			echo "$(date '+%Y-%m-%d %H:%M:%S') sample data not applicable"
		fi
	fi
fi
