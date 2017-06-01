#!/bin/bash

DOMAINS="/opt/glassfish4/glassfish/domains"
ASADMIN="/opt/glassfish4/glassfish/bin/asadmin"

# Build or choose resources for auth mode
if [ $AUTH_MODE == "SAML_SP" ]; then
	wget $IDP_WSDL_URL -O /opt/sso/STSService.xml
	/usr/bin/envsubst < /opt/templates/wsit-client.xml.template > /opt/sso/wsit-client.xml
	zip /opt/sso/OSCM-wsit /opt/sso/STSService.xml /opt/sso/wsit-client.xml
	mv /opt/sso/OSCM-wsit.zip $DOMAINS/app-domain/lib/OSCM-wsit.jar
else
	if [ $AUTH_MODE != "INTERNAL" ]; then
		echo "$AUTH_MODE is not a valid value for AUTH_MODE"
		exit
	fi
fi

# Generate property files
/usr/bin/envsubst < /opt/templates/domain.xml.app.template > $DOMAINS/app-domain/config/domain.xml
/usr/bin/envsubst < /opt/templates/glassfish-acc.xml.template > $DOMAINS/app-domain/config/glassfish-acc.xml

# Copy certificates
if [ -f /opt/certs/$CERT_FILE ]; then
	keytool -delete -alias s1as -keystore $DOMAINS/app-domain/config/keystore.jks -storepass changeit
	keytool -import -alias s1as -keystore $DOMAINS/app-domain/config/keystore.jks -storepass changeit \
		-noprompt -trustcacerts -file /opt/certs/$CERT_FILE
fi

for f in /opt/certs/*.der /opt/certs/*.crt /opt/certs/*.cer /opt/certs/*.pem
do
	if [ -f $f ]; then
		filename=$(basename "$f")
		filename="${filename%.*}"
		keytool -import -alias $filename -keystore $DOMAINS/app-domain/config/cacerts.jks -storepass changeit\
			-noprompt -trustcacerts -file $f
	fi
done

# Change admin passwords
echo "AS_ADMIN_PASSWORD=" > /opt/newadminpwd
echo "AS_ADMIN_NEWPASSWORD=$DOMAIN_PWD" >> /opt/newadminpwd
echo "AS_ADMIN_PASSWORD=$DOMAIN_PWD" > /opt/adminpwd

$ASADMIN --passwordfile /opt/newadminpwd --user admin change-admin-password --domain_name app-domain
#$ASADMIN --passwordfile /opt/adminpwd --port 8848 enable-secure-admin --domain_name app-domain 

# Generate secret
echo $KEY_SECRET | sha256sum | cut -f1 -d\ | xxd -r -p | head -c 16 > $DOMAINS/app-domain/config/key

# Wait for database
until /usr/bin/psql -h ${DB_HOST_APP} -p ${DB_PORT_APP} -U ${DB_USER_APP} -l >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done

# Start domain
$ASADMIN start-domain --verbose app-domain
