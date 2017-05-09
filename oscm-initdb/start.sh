#!/bin/bash

# Mandatory files (mount these) for DB import from SQL files (IMPORT_DB=true)
# SQL_DUMP_GLOBALS="/sqldump/globals.sql": Dump of the globals (DBs, Schemas, Roles, ...)
# SQL_DUMP_BSS="/sqldump/bss.sql": Dump of the bss database
# SQL_DUMP_BSSJMS="/sqldump/bssjms.sql": Dump of the jms database
# SQL_DUMP_BSSAPP="/sqldump/bssapp.sql": Dump of the app database

# Optional files (mount these for additional features):
# SSO_FILE_BES: SSO properties for BES
#TODO: Include SSO properties template and generate from ENV variables

# Exit on error
trap 'echo ERROR at line $LINENO; exit' ERR

export PGCONNECT_TIMEOUT=2
export PROP_FILE_BES_DB="/properties/bes/db.properties"
export PROP_FILE_BES_CONF="/properties/bes/configsettings.properties"
export SSO_FILE_BES="/properties/bes/sso.properties"
export PROP_FILE_APP_DB="/properties/app/db.properties"
export PROP_FILE_APP_CONF="/properties/app/configsettings.properties"
export PROP_FILE_APP_CONTROLLER_CONF="/properties/app/configsettings_controller.properties"
export SQL_DIR_BES="/opt/sqlscripts/bes"
export SQL_DIR_APP="/opt/sqlscripts/app"
export SQL_TEMP_FILE_BES="/tmp/bes.sql"
export SQL_TEMP_FILE_APP="/tmp/app.sql"
export SQL_DUMP_GLOBALS="/sqldump/globals.sql"
export SQL_DUMP_BSS="/sqldump/bss.sql"
export SQL_DUMP_BSSJMS="/sqldump/bssjms.sql"
export SQL_DUMP_BSSAPP="/sqldump/bssapp.sql"

/usr/bin/mkdir -p /properties/bes
/usr/bin/mkdir -p /properties/app

# Initialize BES DB
if [ ${INIT_BES} = "true" ] && [ ${IMPORT_DB} = "false" ]; then
    # Wait for database server to become ready
    until /usr/bin/psql -h ${DB_HOST_BES} -p ${DB_PORT_BES} -l -U ${DB_SUPERUSER} -q >/dev/null 2>&1; do echo "BES Database not ready - waiting..."; sleep 3s; done
    
    # Generate property files from environment
    /usr/bin/envsubst < /propertytemplates/config.properties.jms.template > /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props/config.properties
    /usr/bin/envsubst < /propertytemplates/db.properties.bes.template > ${PROP_FILE_BES_DB}
    /usr/bin/envsubst < /propertytemplates/configsettings.properties.bes.template > ${PROP_FILE_BES_CONF}
    
    # Create databases, schemas, users and roles
    echo "\set ON_ERROR_STOP" > ${SQL_TEMP_FILE_BES}
    echo "CREATE ROLE ${DB_USER_BES} LOGIN PASSWORD '${DB_PWD_BES}';" >> ${SQL_TEMP_FILE_BES}
  	echo "CREATE DATABASE ${DB_NAME_BES} WITH OWNER=${DB_USER_BES} TEMPLATE=template0 ENCODING='UTF8';" >> ${SQL_TEMP_FILE_BES}
  	echo "\c ${DB_NAME_BES}" >> ${SQL_TEMP_FILE_BES}
  	echo "CREATE SCHEMA ${DB_USER_BES};" >> ${SQL_TEMP_FILE_BES}
  	echo "GRANT ALL PRIVILEGES ON SCHEMA ${DB_USER_BES} TO ${DB_USER_BES};" >> ${SQL_TEMP_FILE_BES}
    echo "CREATE ROLE jmsuser LOGIN PASSWORD 'jmsuser';" >> ${SQL_TEMP_FILE_BES}
  	echo "CREATE DATABASE bssjms WITH OWNER=jmsuser TEMPLATE=template0 ENCODING='UTF8';" >> ${SQL_TEMP_FILE_BES}
  	echo "\c bssjms" >> ${SQL_TEMP_FILE_BES}
  	echo "CREATE SCHEMA jmsuser;" >> ${SQL_TEMP_FILE_BES}
  	echo "GRANT ALL PRIVILEGES ON SCHEMA jmsuser TO jmsuser;" >> ${SQL_TEMP_FILE_BES}
    /usr/bin/psql -h ${DB_HOST_BES} -p ${DB_PORT_BES} -U ${DB_SUPERUSER} -f ${SQL_TEMP_FILE_BES}
    /usr/bin/rm -f ${SQL_TEMP_FILE_BES}
    
    # bss DB
    # Initialize and update data
    /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler ${PROP_FILE_BES_DB} ${SQL_DIR_BES}
    # Import properties
    /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.propertyimport.PropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" ${DB_USER_BES} ${DB_PWD_BES} ${PROP_FILE_BES_CONF}
    # Import SSO properties
    if [ -f ${SSO_FILE_BES} ]; then
        /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.ssopropertyimport.SSOPropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" ${DB_USER_BES} ${DB_PWD_BES} ${PROP_FILE_BES_DB} ${SSO_FILE_BES}
    fi
    
    # jms DB
    # Initialize data
    /opt/glassfish3/mq/bin/imqdbmgr recreate tbl -varhome /opt/glassfish3/glassfish/domains/master-indexer-domain/imq -javahome /usr/lib/jvm/java
fi

# Initialize APP DB
if [ ${INIT_APP} = "true" ] && [ ${IMPORT_DB} = "false" ]; then    
    # Wait for database server to become ready
    until /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -l -U ${DB_SUPERUSER} -q >/dev/null 2>&1; do echo "APP Database not ready - waiting..."; sleep 3s; done
    
    # Generate property files from environment
    /usr/bin/envsubst < /propertytemplates/db.properties.app.template > ${PROP_FILE_APP_DB}
    /usr/bin/envsubst < /propertytemplates/configsettings.properties.app.template > ${PROP_FILE_APP_CONF}
    if [ ${INIT_CONTROLLER} = "true" ]; then
        /usr/bin/envsubst < /propertytemplates/configsettings_controller.properties.app.template > ${PROP_FILE_APP_CONTROLLER_CONF}
    fi
    
    # Create databases, schemas, users and roles
    echo "\set ON_ERROR_STOP" > ${SQL_TEMP_FILE_APP}
    echo "CREATE ROLE ${DB_USER_APP} LOGIN PASSWORD '${DB_PWD_APP}';" >> ${SQL_TEMP_FILE_APP}
    echo "CREATE DATABASE ${DB_NAME_APP} WITH OWNER=${DB_USER_APP} TEMPLATE=template0 ENCODING='UTF8';" >> ${SQL_TEMP_FILE_APP}
    echo "\c ${DB_NAME_APP}" >> ${SQL_TEMP_FILE_APP}
    echo "CREATE SCHEMA ${DB_USER_APP};" >> ${SQL_TEMP_FILE_APP}
    echo "GRANT ALL PRIVILEGES ON SCHEMA ${DB_USER_APP} TO ${DB_USER_APP};" >> ${SQL_TEMP_FILE_APP}
    /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_SUPERUSER} -f ${SQL_TEMP_FILE_APP}
    /usr/bin/rm -f ${SQL_TEMP_FILE_APP}
    
    #UPDATE.dbSchemaSingle
    # Initialize and update data
    /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler ${PROP_FILE_APP_DB} ${SQL_DIR_APP}
    # Import APP properties
    /usr/bin/java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" ${DB_USER_APP} ${DB_PWD_APP} ${PROP_FILE_APP_CONF} true
    # Import controller properties
    #if [ -f ${PROP_FILE_APP_CONTROLLER_CONF} ]; then
    if [ ${INIT_CONTROLLER} = "true" ]; then
        /usr/bin/java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" ${DB_USER_APP} ${DB_PWD_APP} ${PROP_FILE_APP_CONTROLLER_CONF} true CONTROLLER
    fi
    # Import SSO properties
    if [ -f ${SSO_FILE_APP} ]; then
        /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.ssopropertyimport.SSOPropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" ${DB_USER_BES} ${DB_PWD_BES} ${PROP_FILE_BES_DB} ${SSO_FILE_BES}
    fi
fi

# Import SQL dumps
if [ ${IMPORT_DB} = "true" ]; then
    if [ -f ${SQL_DUMP_GLOBALS}.gz ]; then
        /usr/bin/gunzip -c ${SQL_DUMP_GLOBALS}.gz > ${SQL_DUMP_GLOBALS}
    fi
    if [ -f ${SQL_DUMP_BSS}.gz ]; then
        /usr/bin/gunzip -c ${SQL_DUMP_BSS}.gz > ${SQL_DUMP_BSS}
    fi
    if [ -f ${SQL_DUMP_BSSJMS}.gz ]; then
        /usr/bin/gunzip -c ${SQL_DUMP_BSSJMS}.gz > ${SQL_DUMP_BSSJMS}
    fi
    if [ -f ${SQL_DUMP_BSSAPP}.gz ]; then
        /usr/bin/gunzip -c ${SQL_DUMP_BSSAPP}.gz > ${SQL_DUMP_BSSAPP}
    fi
    /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_SUPERUSER} -f ${SQL_DUMP_GLOBALS}
    /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_SUPERUSER} -f ${SQL_DUMP_BSS}
    /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_SUPERUSER} -f ${SQL_DUMP_BSSJMS}
    /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_SUPERUSER} -f ${SQL_DUMP_BSSAPP}
fi
