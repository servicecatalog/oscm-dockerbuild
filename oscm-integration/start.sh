#!/bin/bash

DOMAINS="/opt/glassfish4/glassfish/domains"
ASADMIN="/opt/glassfish4/glassfish/bin/asadmin"

# Generate property files
/usr/bin/envsubst < /opt/templates/domain.xml.example.template > $DOMAINS/example-domain/config/domain.xml
/usr/bin/envsubst < /opt/templates/glassfish-acc.xml.template > $DOMAINS/example-domain/config/glassfish-acc.xml
/usr/bin/envsubst < /opt/templates/config.properties.example.template > $DOMAINS/example-domain/imq/instances/imqbroker/props/config.properties

# Copy certificates
if [ -f /opt/certs/$CERT_FILE ]; then
	keytool -delete -alias s1as -keystore $DOMAINS/example-domain/config/keystore.jks -storepass changeit
	keytool -import -alias s1as -keystore $DOMAINS/example-domain/config/keystore.jks -storepass changeit \
		-noprompt -trustcacerts -file /opt/certs/$CERT_FILE
fi

for f in /opt/certs/*.der /opt/certs/*.crt /opt/certs/*.cer /opt/certs/*.pem
do
	if [ -f $f ]; then
		filename=$(basename "$f")
		filename="${filename%.*}"
		keytool -import -alias $filename -keystore $DOMAINS/example-domain/config/cacerts.jks -storepass changeit\
			-noprompt -trustcacerts -file $f
	fi
done

# Change admin passwords
echo "AS_ADMIN_PASSWORD=" > /opt/newadminpwd
echo "AS_ADMIN_NEWPASSWORD=$DOMAIN_PWD" >> /opt/newadminpwd
echo "AS_ADMIN_PASSWORD=$DOMAIN_PWD" > /opt/adminpwd

$ASADMIN --passwordfile /opt/newadminpwd --user admin change-admin-password --domain_name example-domain

# Generate secret
echo $KEY_SECRET | sha256sum | cut -f1 -d\ | xxd -r -p | head -c 16 > $DOMAINS/example-domain/config/key

# Wait for database
/usr/bin/touch /root/.pgpass
/usr/bin/chmod 600 /root/.pgpass
echo "${DB_HOST_BES}:${DB_PORT_BES}:bss:${DB_USER_BES}:${DB_PWD_BES}" > /root/.pgpass
export PGPASSFILE=/root/.pgpass
until /usr/bin/psql -h ${DB_HOST_BES} -p ${DB_PORT_BES} -U ${DB_USER_BES} -l ${DB_NAME_BES} >/dev/null 2>&1; do echo "Database not ready - waiting..."; sleep 3s; done
/usr/bin/rm -f /root/.pgpass

# Start domains
$ASADMIN start-domain --verbose example-domain
