#!/bin/bash
export PGCONNECT_TIMEOUT=2
export PROP_FILE_BES_DB="/properties/bes/db.properties"
export PROP_FILE_BES_CONF="/properties/bes/configsettings.properties"
export SSO_FILE_BES="/properties/bes/sso.properties"
#export PROP_FILE_JMS_DB="/properties/jms/db.properties"
export PROP_FILE_APP_DB="/properties/app/db.properties"
export PROP_FILE_APP_CONF="/properties/app/configsettings.properties" #UNUSED
export SQL_BES="/opt/sqlscripts/bes"
export SQL_APP="/opt/sqlscripts/app"
export SQL_FILE_BES="/tmp/bes.sql"
export SQL_FILE_APP="/tmp/app.sql" #UNUSED

# Initialize BES DB
if [ $INIT_BES = "true" ] && [ -f ${PROP_FILE_BES_DB} ]; then
    export DB_HOST_BES=$(sed -n -e 's|^db.host=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_PORT_BES=$(sed -n -e 's|^db.port=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_NAME_BES=$(sed -n -e 's|^db.name=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_USER_BES=$(sed -n -e 's|^db.user=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    export DB_PWD_BES=$(sed -n -e 's|^db.pwd=\(.*\)$|\1|gp' ${PROP_FILE_BES_DB})
    #export DB_NAME_JMS=$(sed -n -e 's|^db.name=\(.*\)$|\1|gp' ${PROP_FILE_JMS_DB})
    #export DB_USER_JMS=$(sed -n -e 's|^db.user=\(.*\)$|\1|gp' ${PROP_FILE_JMS_DB})
    #export DB_PWD_JMS=$(sed -n -e 's|^db.pwd=\(.*\)$|\1|gp' ${PROP_FILE_JMS_DB})
    
    # Wait for Database to become ready
    until /usr/bin/psql -h ${DB_HOST_BES} -p ${DB_PORT_BES} -l -U ${DB_SUPERUSER} -q >/dev/null 2>&1; do echo "BES Database not ready - waiting..."; sleep 3s; done
    
    # Do initial DB stuff
    echo "\set ON_ERROR_STOP" > ${SQL_FILE_BES}
    echo "CREATE ROLE ${DB_USER_BES} LOGIN PASSWORD '${DB_PWD_BES}';" >> ${SQL_FILE_BES}
    echo "CREATE ROLE jmsuser LOGIN PASSWORD 'jmsuser';" >> ${SQL_FILE_BES}
  	echo "CREATE DATABASE ${DB_NAME_BES} WITH OWNER=${DB_USER_BES} TEMPLATE=template0 ENCODING='UTF8';" >> ${SQL_FILE_BES}
  	echo "\c ${DB_NAME_BES}" >> ${SQL_FILE_BES}
  	echo "CREATE SCHEMA ${DB_USER_BES};" >> ${SQL_FILE_BES}
  	echo "GRANT ALL PRIVILEGES ON SCHEMA ${DB_USER_BES} TO ${DB_USER_BES};" >> ${SQL_FILE_BES}
  	echo "CREATE DATABASE bssjms WITH OWNER=jmsuser TEMPLATE=template0 ENCODING='UTF8';" >> ${SQL_FILE_BES}
  	echo "\c bssjms" >> ${SQL_FILE_BES}
  	echo "CREATE SCHEMA jmsuser;" >> ${SQL_FILE_BES}
  	echo "GRANT ALL PRIVILEGES ON SCHEMA jmsuser TO jmsuser;" >> ${SQL_FILE_BES}
    /usr/bin/psql -h ${DB_HOST_BES} -p ${DB_PORT_BES} -U ${DB_SUPERUSER} -f ${SQL_FILE_BES}
    /usr/bin/rm -f ${SQL_FILE_BES}
    
    # bss DB
    /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler ${PROP_FILE_BES_DB} ${SQL_BES}
    /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.propertyimport.PropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" ${DB_USER_BES} ${DB_PWD_BES} ${PROP_FILE_BES_CONF}
    if [ -f ${SSO_FILE_BES} ]; then
        /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.ssopropertyimport.SSOPropertyImport org.postgresql.Driver "jdbc:postgresql://${DB_HOST_BES}:${DB_PORT_BES}/${DB_NAME_BES}" ${DB_USER_BES} ${DB_PWD_BES} ${PROP_FILE_BES_DB} ${SSO_FILE_BES}
    fi
    
    # jms DB
    /opt/glassfish3/mq/bin/imqdbmgr recreate tbl -varhome /opt/glassfish3/glassfish/domains/master-indexer-domain/imq -javahome /usr/lib/jvm/java
fi


# Initialize APP DB
if [ $INIT_APP = "true" ] && [ -f ${PROP_FILE_APP_DB} ]; then
    export DB_HOST_APP=$(sed -n -e 's|^db.host=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_PORT_APP=$(sed -n -e 's|^db.port=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_NAME_APP=$(sed -n -e 's|^db.name=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_USER_APP=$(sed -n -e 's|^db.user=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    export DB_PWD_APP=$(sed -n -e 's|^db.pwd=\(.*\)$|\1|gp' ${PROP_FILE_APP_DB})
    until /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -l -U ${DB_SUPERUSER} -q >/dev/null 2>&1; do echo "APP Database not ready - waiting..."; sleep 3s; done
    
    # Do initial DB stuff
    
    /usr/bin/java -cp "/opt/oscm-devruntime.jar:/opt/lib/*" org.oscm.setup.DatabaseUpgradeHandler ${PROP_FILE_APP_DB} ${SQL_APP}
fi
