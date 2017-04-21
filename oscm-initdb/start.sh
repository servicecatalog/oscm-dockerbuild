#!/bin/bash

# Mandatory environment variables (override if required):
# DB_SUPERUSER: Postgres superuser name (default: postgres)
# PGPASSWORD: Postgres superuser password (default: postgres)
# INIT_BES: Set to true to initialize BES and Master Indexer databases (default: false)
# INIT_APP: Set to true to initialize APP database (default: false)

# Mandatory files (mount these):
# PROP_FILE_BES_DB: BES DB properties file
# PROP_FILE_BES_CONF: BES configuration properties file
# PROP_FILE_APP_DB: APP DB properties file
# PROP_FILE_APP_CONF: APP configuration properties file

# Optional files (mount these for additional features):
# SSO_FILE_BES: SSO properties for BES
# PROP_FILE_APP_CONTROLLER_CONF: Properties for APP controller

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

# Initialize BES DB
if [ $INIT_BES = "true" ] && [ -f ${PROP_FILE_BES_DB} ]; then
    export DB_HOST_BES=$(sed -n -e 's|^db.host=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_PORT_BES=$(sed -n -e 's|^db.port=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_NAME_BES=$(sed -n -e 's|^db.name=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_USER_BES=$(sed -n -e 's|^db.user=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_PWD_BES=$(sed -n -e 's|^db.pwd=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    
    # Wait for database server to become ready
    until /usr/bin/psql -h ${DB_HOST_BES} -p ${DB_PORT_BES} -l -U ${DB_SUPERUSER} -q >/dev/null 2>&1; do echo "BES Database not ready - waiting..."; sleep 3s; done
    
    # Prepare config file for jms DB
    /usr/bin/sed -i "s|__DB_HOST_BES__|$DB_HOST_BES|g" /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props/config.properties
    /usr/bin/sed -i "s|__DB_PORT_BES__|$DB_PORT_BES|g" /opt/glassfish3/glassfish/domains/master-indexer-domain/imq/instances/imqbroker/props/config.properties
    
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
if [ $INIT_APP = "true" ] && [ -f ${PROP_FILE_APP_DB} ]; then
    export DB_HOST_APP=$(sed -n -e 's|^db.host=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_PORT_APP=$(sed -n -e 's|^db.port=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_NAME_APP=$(sed -n -e 's|^db.name=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_USER_APP=$(sed -n -e 's|^db.user=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_PWD_APP=$(sed -n -e 's|^db.pwd=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    
    # Wait for database server to become ready
    until /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -l -U ${DB_SUPERUSER} -q >/dev/null 2>&1; do echo "APP Database not ready - waiting..."; sleep 3s; done
    
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
    if [ -f ${PROP_FILE_APP_CONTROLLER_CONF} ]; then
        /usr/bin/java -cp "/opt/oscm-app.jar:/opt/lib/*" org.oscm.app.setup.PropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_APP}:${DB_PORT_APP}/${DB_NAME_APP}" ${DB_USER_APP} ${DB_PWD_APP} ${PROP_FILE_APP_CONTROLLER_CONF} true CONTROLLER
    fi
    # Import SSO properties
    if [ -f ${SSO_FILE_APP} ]; then
        /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.ssopropertyimport.SSOPropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" ${DB_USER_BES} ${DB_PWD_BES} ${PROP_FILE_BES_DB} ${SSO_FILE_BES}
    fi
fi
