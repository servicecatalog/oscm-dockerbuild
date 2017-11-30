#!/bin/bash

REPO_DOCKER="`dirname \"$0\"`"
REPO_OSCM="$1"
BUILD_DIR="$REPO_OSCM/oscm-build/result/package"
LIB_DIR="$REPO_OSCM/libraries"

# prepare common certificate and key
openssl rand -base64 48 > /tmp/passphrase.txt
openssl genrsa -aes128 -passout file:/tmp/passphrase.txt -out /tmp/ssl.key 2048
openssl req -new -passin file:/tmp/passphrase.txt -key /tmp/ssl.key -out /tmp/ssl.csr -subj "/CN=localhost"
cp /tmp/ssl.key /tmp/ssl.key.pass
openssl rsa -in /tmp/ssl.key.pass -passin file:/tmp/passphrase.txt -out /tmp/ssl.key
openssl x509 -req -days 3650 -in /tmp/ssl.csr -signkey /tmp/ssl.key -out /tmp/ssl.crt
rm -f /tmp/passphrase.txt /tmp/ssl.key.pass /tmp/ssl.csr

# copy resources for initdb

## copy resources for core
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/org/postgresql/postgresql/42.1.4/postgresql-42.1.4.jar -O $REPO_DOCKER/oscm-core/postgresql.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/log4j/log4j/1.2.16/log4j-1.2.16.jar -O $REPO_DOCKER/oscm-core/log4j.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/commons-validator/commons-validator/1.4.0/commons-validator-1.4.0.jar -O $REPO_DOCKER/oscm-core/commons-validator.jar

# applications
wget -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm/oscm-ear/fb_tomee_maven-v17.4.0-g0363f06-311/oscm-ear-fb_tomee_maven-v17.4.0-g0363f06-311.ear -O $REPO_DOCKER/oscm-core/oscm-ear.ear

# libs
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm/oscm-security/fb_tomee_maven-v17.4.0-g0363f06-311/oscm-security-fb_tomee_maven-v17.4.0-g0363f06-311.jar -O $REPO_DOCKER/oscm-core/oscm-security.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm/oscm-saml2-api/fb_tomee_maven-v17.4.0-g0363f06-311/oscm-saml2-api-fb_tomee_maven-v17.4.0-g0363f06-311.jar -O $REPO_DOCKER/oscm-core/oscm-saml2-api.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-commons/oscm-common/1.3/oscm-common-1.3.jar -O $REPO_DOCKER/oscm-core/oscm-common.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-commons/oscm-rest-api-common/1.3/oscm-rest-api-common-1.3.jar -O $REPO_DOCKER/oscm-core/oscm-rest-api-common.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc-internal/1.2/oscm-extsvc-internal-1.2.jar -O $REPO_DOCKER/oscm-core/oscm-extsvc-internal.jar

## copy resources for app
# applictaions
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-app/oscm-app-ear/master-c6c0aae465-1/oscm-app-ear-master-c6c0aae465-1.ear -o $REPO_DOCKER/oscm-app/oscm-app.ear
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-app-aws/oscm-app-aws-ear/master-28c31ec4af-1/oscm-app-aws-ear-master-28c31ec4af-1.ear -O $REPO_DOCKER/oscm-app/oscm-app-aws.ear
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-app-openstack/oscm-app-openstack-ear/master-3d0c1ed0ed-1/oscm-app-openstack-ear-master-3d0c1ed0ed-1.ear -O $REPO_DOCKER/oscm-app/oscm-app-openstack.ear

# libs
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-app-extsvc/1.2/oscm-app-extsvc-1.2.jar -O $REPO_DOCKER/oscm-app/oscm-app-extsvc.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-commons/oscm-common/1.3/oscm-common-1.3.jar -O $REPO_DOCKER/oscm-app/oscm-common.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc/1.2/oscm-extsvc-1.2.jar -O $REPO_DOCKER/oscm-app/oscm-extsvc.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 https://jitpack.io/com/github/servicecatalog/oscm-interfaces/oscm-extsvc-internal/1.2/oscm-extsvc-internal-1.2.jar -O $REPO_DOCKER/oscm-app/oscm-extsvc-internal.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/org/postgresql/postgresql/42.1.4/postgresql-42.1.4.jar -O $REPO_DOCKER/oscm-app/postgresql.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/log4j/log4j/1.2.16/log4j-1.2.16.jar -O $REPO_DOCKER/oscm-app/log4j.jar

## birt
#cp $BUILD_DIR/oscm-reports/oscm-reports.zip $REPO_DOCKER/oscm-core/
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/javax/activation/activation/1.1/activation-1.1.jar -O $REPO_DOCKER/oscm-birt/activation.jar
wget -q -e use_proxy=yes -e https_proxy=proxy.intern.est.fujitsu.com:8080 http://central.maven.org/maven2/javax/mail/javax.mail-api/1.5.4/javax.mail-api-1.5.4.jar -O $REPO_DOCKER/oscm-birt/javax.mail-api.jar

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
