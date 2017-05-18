#!/bin/bash

DOMAINS="/opt/glassfish4/glassfish/domains"
ASADMIN="/opt/glassfish4/glassfish/bin/asadmin"

# Choose correct oscm ear for auth mode
if [ $AUTH_MODE == "INTERNAL" ]; then
    cp -f /opt/ear/oscm.ear $DOMAINS/bes-domain/autodeploy/oscm.ear
else
	if [ $AUTH_MODE == "SAML_SP" ]; then
		cp -f /opt/ear/oscm-sso.ear $DOMAINS/bes-domain/autodeploy/oscm.ear
	else
		echo "$AUTH_MODE is not a valid value for AUTH_MODE"
		exit
	fi
fi

# Generate property files
/usr/bin/envsubst < /opt/templates/db.properties.bes.template > /opt/properties/db.properties
/usr/bin/envsubst < /opt/templates/configsettings.properties.bes.template > /opt/properties/configsettings.properties
/usr/bin/envsubst < /opt/templates/domain.xml.bes.template > $DOMAINS/bes-domain/config/domain.xml
/usr/bin/envsubst < /opt/templates/domain.xml.mi.template > $DOMAINS/master-indexer-domain/config/domain.xml
/usr/bin/envsubst < /opt/templates/glassfish-acc.xml.template > $DOMAINS/bes-domain/config/glassfish-acc.xml
/usr/bin/envsubst < /opt/templates/glassfish-acc.xml.template > $DOMAINS/master-indexer-domain/config/glassfish-acc.xml
/usr/bin/envsubst < /opt/templates/config.properties.template > $DOMAINS/bes-domain/imq/instances/imqbroker/props/config.properties
/usr/bin/envsubst < /opt/templates/config.properties.template > $DOMAINS/master-indexer-domain/imq/instances/imqbroker/props/config.properties

# Copy certificates
if [ -f /opt/certs/$CERT_FILE ]; then
	keytool -delete -alias s1as -keystore $DOMAINS/bes-domain/config/keystore.jks -keypass changeit
	keytool -import -alias s1as -keystore $DOMAINS/bes-domain/config/keystore.jks -keypass changeit \
		-noprompt -trustcacerts -file /opt/certs/$CERT_FILE
		
	keytool -delete -alias s1as -keystore $DOMAINS/master-indexer-domain/config/keystore.jks -keypass changeit
	keytool -import -alias s1as -keystore $DOMAINS/master-indexer-domain/config/keystore.jks -keypass changeit \
		-noprompt -trustcacerts -file /opt/certs/$CERT_FILE
fi

for f in /opt/certs/*.der /opt/certs/*.crt /opt/certs/*.cer /opt/certs/*.pem
do
	filename=$(basename "$f")
	filename="${filename%.*}"
	keytool -import -alias filename -keystore $DOMAINS/bes-domain/config/cacerts.jks -keypass changeit \
		-noprompt -trustcacerts -file /opt/certs/$CERT_FILE
done

# Change admin passwords
echo "AS_ADMIN_PASSWORD=" > /opt/newadminpwd
echo "AS_ADMIN_NEWPASSWORD=$DOMAIN_PWD" >> /opt/newadminpwd
echo "AS_ADMIN_PASSWORD=$DOMAIN_PWD" > /opt/adminpwd

$ASADMIN --passwordfile /opt/newadminpwd --domain_name bes-domain change-admin-password
$ASADMIN --passwordfile /opt/adminpwd --domain_name bes-domain enable-secure-admin

$ASADMIN --passwordfile /opt/newadminpwd --domain_name master-indexer-domain change-admin-password
$ASADMIN --passwordfile /opt/adminpwd --domain_name master-indexer-domain enable-secure-admin

# Generate secret
echo $KEY_SECRET | sha256sum | cut -f1 -d\ | xxd -r -p | head -c 16 > $DOMAINS/bes-domain/config/key

# Wait for database
until psql -h $DB_HOST_BES -l -U $DB_USER_BES -q >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done

# Start domains
$ASADMIN start-domain master-indexer-domain
$ASADMIN start-domain --verbose bes-domain
