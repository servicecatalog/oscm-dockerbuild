#!/bin/bash

REPO_DOCKER="`dirname \"$0\"`"
REPO_OSCM="$1"
TAG_REPO_DEVELOPMENT="$2"
BUILD_DIR="$REPO_OSCM/oscm-build/result/package"
LIB_DIR="$REPO_OSCM/libraries"
OSCM_INTERFACES_BUILD_VERSION="$3"
OSCM_COMMONS_BUILD_VERSION="$4"

# prepare common certificate and key
openssl rand -base64 48 > /tmp/passphrase.txt
openssl genrsa -aes128 -passout file:/tmp/passphrase.txt -out /tmp/ssl.key 2048
openssl req -new -passin file:/tmp/passphrase.txt -key /tmp/ssl.key -out /tmp/ssl.csr -subj "/CN=localhost"
cp /tmp/ssl.key /tmp/ssl.key.pass
openssl rsa -in /tmp/ssl.key.pass -passin file:/tmp/passphrase.txt -out /tmp/ssl.key
openssl x509 -req -days 3650 -in /tmp/ssl.csr -signkey /tmp/ssl.key -out /tmp/ssl.crt
rm -f /tmp/passphrase.txt /tmp/ssl.key.pass /tmp/ssl.csr

OSCM_BUILD_VERSION=$(curl -x https://proxy.intern.est.fujitsu.com:8080 -Ls -o /dev/null -w %{url_effective} https://jitpack.io/com/github/servicecatalog/oscm/$TAG_REPO_DEVELOPMENT/build.log | awk -F '/' '{print $(NF-1)}')
# copy resources for initdb
mkdir $REPO_DOCKER/oscm-initdb/libs/
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0-linux-x64.tar.gz -O $REPO_DOCKER/oscm-initdb/flyway.tar.gz
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar -O $REPO_DOCKER/oscm-initdb/libs/commons-logging.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/commons-validator/commons-validator/1.4.0/commons-validator-1.4.0.jar -O $REPO_DOCKER/oscm-initdb/libs/commons-validator.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/log4j/log4j/1.2.16/log4j-1.2.16.jar -O $REPO_DOCKER/oscm-initdb/libs/log4j.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/oro/oro/2.0.8/oro-2.0.8.jar -O $REPO_DOCKER/oscm-initdb/libs/oro.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-commons/oscm-common/$OSCM_COMMONS_BUILD_VERSION/oscm-common-$OSCM_COMMONS_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-initdb/libs/oscm-common.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm/oscm-devruntime/${OSCM_BUILD_VERSION}/oscm-devruntime-${OSCM_BUILD_VERSION}.jar -O $REPO_DOCKER/oscm-initdb/libs/oscm-devruntime.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc/$OSCM_INTERFACES_BUILD_VERSION/oscm-extsvc-$OSCM_INTERFACES_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-initdb/libs/oscm-extsvc.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc-internal/$OSCM_INTERFACES_BUILD_VERSION/oscm-extsvc-internal-$OSCM_INTERFACES_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-initdb/libs/oscm-extsvc-internal.jar

## copy resources for core
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/org/postgresql/postgresql/42.1.4/postgresql-42.1.4.jar -O $REPO_DOCKER/oscm-core/postgresql.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/log4j/log4j/1.2.16/log4j-1.2.16.jar -O $REPO_DOCKER/oscm-core/log4j.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/commons-validator/commons-validator/1.4.0/commons-validator-1.4.0.jar -O $REPO_DOCKER/oscm-core/commons-validator.jar

# applications
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm/oscm-ear/${OSCM_BUILD_VERSION}/oscm-ear-${OSCM_BUILD_VERSION}.ear -O $REPO_DOCKER/oscm-core/oscm.ear

# libs
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm/oscm-security/${OSCM_BUILD_VERSION}/oscm-security-${OSCM_BUILD_VERSION}.jar -O $REPO_DOCKER/oscm-core/oscm-security.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm/oscm-saml2-api/${OSCM_BUILD_VERSION}/oscm-saml2-api-${OSCM_BUILD_VERSION}.jar -O $REPO_DOCKER/oscm-core/oscm-saml2-api.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-commons/oscm-common/$OSCM_COMMONS_BUILD_VERSION/oscm-common-$OSCM_COMMONS_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-core/oscm-common.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-commons/oscm-rest-api-common/$OSCM_COMMONS_BUILD_VERSION/oscm-rest-api-common-$OSCM_COMMONS_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-core/oscm-rest-api-common.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc-internal/$OSCM_INTERFACES_BUILD_VERSION/oscm-extsvc-internal-$OSCM_INTERFACES_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-core/oscm-extsvc-internal.jar

## copy resources for app
# applictaions
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-app/oscm-app-ear/master-1fa8b825b1-1/oscm-app-ear-master-1fa8b825b1-1.ear -o $REPO_DOCKER/oscm-app/oscm-app.ear
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-app-aws/oscm-app-aws-ear/master-28c31ec4af-1/oscm-app-aws-ear-master-28c31ec4af-1.ear -O $REPO_DOCKER/oscm-app/oscm-app-aws.ear
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-app-openstack/oscm-app-openstack-ear/master-3d0c1ed0ed-1/oscm-app-openstack-ear-master-3d0c1ed0ed-1.ear -O $REPO_DOCKER/oscm-app/oscm-app-openstack.ear
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-app/oscm-app/master-1fa8b825b1-1/oscm-app-master-1fa8b825b1-1.jar -O $REPO_DOCKER/oscm-app/libs/oscm-app.jar

# libs
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-app-extsvc/$OSCM_INTERFACES_BUILD_VERSION/oscm-app-extsvc-$OSCM_INTERFACES_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-app/oscm-app-extsvc.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-commons/oscm-common/$OSCM_COMMONS_BUILD_VERSION/oscm-common-$OSCM_COMMONS_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-app/oscm-common.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc/$OSCM_INTERFACES_BUILD_VERSION/oscm-extsvc-$OSCM_INTERFACES_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-app/oscm-extsvc.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc-internal/$OSCM_INTERFACES_BUILD_VERSION/oscm-extsvc-internal-$OSCM_INTERFACES_BUILD_VERSION.jar -O $REPO_DOCKER/oscm-app/oscm-extsvc-internal.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/org/postgresql/postgresql/42.1.4/postgresql-42.1.4.jar -O $REPO_DOCKER/oscm-app/postgresql.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/log4j/log4j/1.2.16/log4j-1.2.16.jar -O $REPO_DOCKER/oscm-app/log4j.jar

## birt
#cp $BUILD_DIR/oscm-reports/oscm-reports.zip $REPO_DOCKER/oscm-core/
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/javax/activation/activation/1.1/activation-1.1.jar -O $REPO_DOCKER/oscm-birt/activation.jar
wget -q -e use_proxy=yes -e http_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/javax/mail/javax.mail-api/1.5.4/javax.mail-api-1.5.4.jar -O $REPO_DOCKER/oscm-birt/javax.mail-api.jar

#cp $BUILD_DIR/oscm-portal-help/oscm-portal-help.war $REPO_DOCKER/oscm-help/

##copy ssl related resources
cp /tmp/ssl.crt $REPO_DOCKER/oscm-core/
cp /tmp/ssl.key $REPO_DOCKER/oscm-core/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-app/
cp /tmp/ssl.key $REPO_DOCKER/oscm-app/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-birt/
cp /tmp/ssl.key $REPO_DOCKER/oscm-birt/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-branding/
cp /tmp/ssl.key $REPO_DOCKER/oscm-branding/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-proxy/
cp /tmp/ssl.key $REPO_DOCKER/oscm-proxy/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-help/
cp /tmp/ssl.key $REPO_DOCKER/oscm-help/
