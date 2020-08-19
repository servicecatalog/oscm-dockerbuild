#!/bin/bash

 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

REPO_DOCKER="`dirname \"$0\"`"
REPO_OSCM="$1"
BUILD_DIR="$REPO_OSCM/oscm-build/result/package"
OSCM_APP="$REPO_OSCM/oscm-app-maven"
REST_API="$REPO_OSCM/oscm-rest-api"
BUILD_SHELL_DIR="$REPO_OSCM/oscm-app-shell/target"
BUILD_IDENTITY_DIR="$REPO_OSCM/oscm-identity/target"
LIB_DIR="$REPO_OSCM/libraries"


# prepare common certificate and key
openssl rand -base64 48 > /tmp/passphrase.txt
openssl genrsa -aes128 -passout file:/tmp/passphrase.txt -out /tmp/ssl.key 2048
openssl req -new -passin file:/tmp/passphrase.txt -key /tmp/ssl.key -out /tmp/ssl.csr -subj "/CN=localhost"
cp /tmp/ssl.key /tmp/ssl.key.pass
openssl rsa -in /tmp/ssl.key.pass -passin file:/tmp/passphrase.txt -out /tmp/ssl.key
openssl x509 -req -days 3650 -in /tmp/ssl.csr -signkey /tmp/ssl.key -out /tmp/ssl.crt
rm -f /tmp/passphrase.txt /tmp/ssl.key.pass /tmp/ssl.csr

# copy resource for glassfish
cp $LIB_DIR/postgresql-jdbc/javalib/postgresql-9.4-1206-jdbc42.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-codec/javalib/commons-codec-1.7.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-log4j/javalib/log4j-api-2.13.0.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-log4j/javalib/log4j-core-2.13.0.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-validator/javalib/commons-validator-1.4.0.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-logging/javalib/commons-logging-1.1.3.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/jakarta-oro/javalib/jakarta-oro-2.0.8.jar $REPO_DOCKER/oscm-gf/

cp $LIB_DIR/redhat-hibernate/javalib/jboss-logging.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-lucene/javalib/lucene-analyzers-common-5.3.1.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-lucene/javalib/lucene-core-5.3.1.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-logging/javalib/commons-logging-1.1.3.jar $REPO_DOCKER/oscm-gf/

# copy resources for tomee
cp $LIB_DIR/redhat-hibernate/javalib/hibernate-commons-annotations-5.0.1.Final.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/redhat-hibernate/javalib/hibernate-core-5.0.9.Final.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/redhat-hibernate/javalib/hibernate-entitymanager-5.0.9.Final.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/redhat-hibernate/javalib/hibernate-jpa-2.1-api-1.0.0.Final.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/jackson/javalib/jackson-annotations.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/jackson/javalib//jackson-core.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/jackson/javalib//jackson-databind.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/redhat-hibernate/javalib/jboss-logging.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/redhat-hibernate/javalib/dom4j-1.6.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/redhat-hibernate/javalib/antlr-2.7.7.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/jboss-hibernate-search/javalib/hibernate-search-orm-5.5.4.Final.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/jboss-hibernate-search/javalib/hibernate-search-engine-5.5.4.Final.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/postgresql-jdbc/javalib/postgresql-9.4-1206-jdbc42.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/lucene-analyzers-common-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/lucene-backward-codecs-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/lucene-core-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/lucene-facet-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/lucene-misc-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/lucene-queries-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/lucene-queryparser-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/solr-core-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-lucene/javalib/solr-solrj-5.3.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/antlr/javalib/antlr4-runtime-4.1.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/gson/javalib/gson-2.6.2.jar $REPO_DOCKER/oscm-core/

cp $BUILD_DIR/oscm-ear/oscm.ear $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-portal/oscm-portal.war $REPO_DOCKER/oscm-core/


# copy resources for initdb
cp $OSCM_APP/oscm-app/target/oscm-app.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-common/oscm-common.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-server-common/oscm-server-common.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-extsvc/oscm-extsvc-platform.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-extsvc-internal/oscm-extsvc-internal.jar $REPO_DOCKER/oscm-initdb/
cp $LIB_DIR/apache-log4j/javalib/log4j-core-2.13.0.jar $REPO_DOCKER/oscm-initdb/
cp $LIB_DIR/apache-log4j/javalib/log4j-api-2.13.0.jar $REPO_DOCKER/oscm-initdb/
cp $LIB_DIR/postgresql-jdbc/javalib/postgresql-9.4-1206-jdbc42.jar $REPO_DOCKER/oscm-initdb/
cp $LIB_DIR/apache-validator/javalib/commons-validator-1.4.0.jar $REPO_DOCKER/oscm-initdb/
cp $LIB_DIR/apache-ant-contrib/lib/commons-logging-1.1.3.jar $REPO_DOCKER/oscm-initdb/
cp $LIB_DIR/jakarta-oro/javalib/jakarta-oro-2.0.8.jar $REPO_DOCKER/oscm-initdb/

mkdir -p $REPO_DOCKER/oscm-initdb/sqlscripts/core
cp $REPO_OSCM/oscm-devruntime/javares/sql/*.sql $REPO_DOCKER/oscm-initdb/sqlscripts/core/
mkdir -p $REPO_DOCKER/oscm-initdb/sqlscripts/app
cp $OSCM_APP/oscm-app/resources/sql/*.sql $REPO_DOCKER/oscm-initdb/sqlscripts/app/
mkdir -p $REPO_DOCKER/oscm-initdb/sqlscripts/vmware
cp $OSCM_APP/oscm-app-vmware/resources/sql/*.sql $REPO_DOCKER/oscm-initdb/sqlscripts/vmware/
mkdir -p $REPO_DOCKER/oscm-initdb/sqlscripts/approval
cp $REPO_OSCM/oscm-approval/resources/sql/*.sql $REPO_DOCKER/oscm-initdb/sqlscripts/approval/

# copy resources for core
cp $BUILD_DIR/oscm-search/oscm-search.ear $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-ear/oscm.ear $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-ear/tmp/oscm.ear $REPO_DOCKER/oscm-core/oscm-sso.ear
cp $BUILD_DIR/oscm-portal/oscm-portal.war $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-portal-help/oscm-portal-help.war $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-reports/oscm-reports.zip $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-security/oscm-security.jar $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-common/oscm-common.jar $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-extsvc-internal/oscm-extsvc-internal.jar $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-server-common/oscm-server-common.jar $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-extsvc/oscm-extsvc-platform.jar $REPO_DOCKER/oscm-core/
cp $BUILD_DIR/oscm-rest-api-common/oscm-rest-api-common.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-log4j/javalib/log4j-core-2.13.0.jar $REPO_DOCKER/oscm-core/
cp $LIB_DIR/apache-log4j/javalib/log4j-api-2.13.0.jar $REPO_DOCKER/oscm-core/

# copy rest api war for core
cp $REST_API/oscm-rest-api-uberwar/target/oscm-rest-api.war $REPO_DOCKER/oscm-core/

# copy resources for app
cp $OSCM_APP/oscm-app-ear/target/oscm-app.ear $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-aws-ear/target/oscm-app-aws.ear $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-openstack-ear/target/oscm-app-openstack.ear $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-azure-ear/target/oscm-app-azure.ear $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-vmware-ear/target/oscm-app-vmware.ear $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-sample-ear/target/oscm-app-sample.ear $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app/target/oscm-app.jar $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-aws/target/oscm-app-aws.jar $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-openstack/target/oscm-app-openstack.jar $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-azure/target/oscm-app-azure.jar $REPO_DOCKER/oscm-app/
cp $OSCM_APP/oscm-app-vmware/target/oscm-app-vmware.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-approval//approval-impl/target/approval-impl-0.0.2-SNAPSHOT.war $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-common/oscm-common.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-extsvc-internal/oscm-extsvc-internal.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-server-common/oscm-server-common.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-extsvc/oscm-extsvc-platform.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-app-extsvc-2-0/oscm-app-extsvc-2-0.jar $REPO_DOCKER/oscm-app/

cp $LIB_DIR/postgresql-jdbc/javalib/postgresql-9.4-1206-jdbc42.jar $REPO_DOCKER/oscm-app/
cp $LIB_DIR/apache-log4j/javalib/log4j-core-2.13.0.jar $REPO_DOCKER/oscm-app/
cp $LIB_DIR/apache-log4j/javalib/log4j-api-2.13.0.jar $REPO_DOCKER/oscm-app/

cp $LIB_DIR/sun-metro/javalib/activation-1.1.jar $REPO_DOCKER/oscm-birt/
cp $LIB_DIR/javax/javalib/javax.mail-api-1.5.4.jar $REPO_DOCKER/oscm-birt/

cp $BUILD_DIR/oscm-portal-help/oscm-portal-help.war $REPO_DOCKER/oscm-help/
cp $BUILD_SHELL_DIR/oscm-app-shell.war $REPO_DOCKER/oscm-app/

# copy resources for identity
cp $BUILD_IDENTITY_DIR/oscm-identity.jar $REPO_DOCKER/oscm-identity/
mkdir $REPO_DOCKER/oscm-deployer/resources
cp $BUILD_IDENTITY_DIR/../config/tenants/tenant-default.properties $REPO_DOCKER/oscm-deployer/resources/

##copy ssl related resources
cp /tmp/ssl.crt $REPO_DOCKER/oscm-core/
cp /tmp/ssl.key $REPO_DOCKER/oscm-core/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-app/
cp /tmp/ssl.key $REPO_DOCKER/oscm-app/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-birt/
cp /tmp/ssl.key $REPO_DOCKER/oscm-birt/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-branding/
cp /tmp/ssl.key $REPO_DOCKER/oscm-branding/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-help/
cp /tmp/ssl.key $REPO_DOCKER/oscm-help/
cp /tmp/ssl.crt $REPO_DOCKER/oscm-identity/
cp /tmp/ssl.key $REPO_DOCKER/oscm-identity/
