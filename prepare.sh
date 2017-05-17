#!/bin/bash

REPO_DOCKER="`dirname \"$0\"`"
REPO_OSCM="$1"
BUILD_DIR="$REPO_OSCM/oscm-build/result/package"
LIB_DIR="$REPO_OSCM/libraries"

# copy resource for glassfish
cp $LIB_DIR/postgresql-jdbc/javalib/postgresql-9.4-1206-jdbc42.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-codec/javalib/commons-codec-1.7.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-log4j/javalib/log4j-1.2.16.jar $REPO_DOCKER/oscm-gf/

cp $LIB_DIR/redhat-hibernate/javalib/jboss-logging.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-lucene/javalib/lucene-analyzers-common-5.3.1.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-lucene/javalib/lucene-core-5.3.1.jar $REPO_DOCKER/oscm-gf/

cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.antlr.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.asm.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.core.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.dbws.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.jpa.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.jpa.jpql.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.jpa.modelgen.processor.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.moxy.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/glassfish4/modules/org.eclipse.persistence.oracle.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/dol/javalib/dol.jar $REPO_DOCKER/oscm-gf/
cp $LIB_DIR/apache-logging/javalib/commons-logging-1.1.3.jar.jar $REPO_DOCKER/oscm-gf/


# copy resources for initdb
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-common/oscm-common.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-server-common/oscm-server-common.jar $REPO_DOCKER/oscm-initdb/
cp $REPO_OSCM/oscm-build/lib/log4j-1.2.16.jar $REPO_DOCKER/oscm-initdb/
cp $REPO_OSCM/oscm-build/lib/postgresql-9.1-903.jdbc4.jar $REPO_DOCKER/oscm-initdb/
cp $REPO_OSCM/oscm-build/lib/commons-validator-1.4.0.jar $REPO_DOCKER/oscm-initdb/
cp $REPO_OSCM/oscm-build/lib/commons-logging-1.1.3.jar $REPO_DOCKER/oscm-initdb/
cp $REPO_OSCM/oscm-build/lib/oro-2.0.8.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-extsvc/oscm-extsvc-platform.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-extsvc-internal/oscm-extsvc-internal.jar $REPO_DOCKER/oscm-initdb/
cp $BUILD_DIR/oscm-app/oscm-app.jar $REPO_DOCKER/oscm-initdb/

mkdir -p $REPO_DOCKER/oscm-initdb/sqlscripts/bes
cp $REPO_OSCM/oscm-devruntime/javares/sql/*.sql $REPO_DOCKER/oscm-initdb/sqlscripts/bes/
mkdir -p $REPO_DOCKER/oscm-initdb/sqlscripts/app
cp $REPO_OSCM/oscm-app/resources/sql/*.sql $REPO_DOCKER/oscm-initdb/sqlscripts/app/

# copy resources for bes
cp $BUILD_DIR/oscm-search/oscm-search.ear $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-ear/oscm.ear $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-ear/tmp/oscm.ear $REPO_DOCKER/oscm-bes/oscm-sso.ear
cp $BUILD_DIR/oscm-portal/oscm-portal.war $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-portal-help/oscm-portal-help.war $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-reports/oscm-reports.zip $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-security/oscm-security.jar $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-common/oscm-common.jar $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-extsvc-internal/oscm-extsvc-internal.jar $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-server-common/oscm-server-common.jar $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-extsvc/oscm-extsvc-platform.jar $REPO_DOCKER/oscm-bes/

mkdir $REPO_DOCKER/oscm-bes/sqlscripts
cp $REPO_OSCM/oscm-devruntime/javares/sql/*.sql $REPO_DOCKER/oscm-bes/sqlscripts/

# copy resources for app
cp $BUILD_DIR/oscm-app-ear/oscm-app.ear $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-app-aws/oscm-app-aws.ear $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-app-sample/oscm-app-sample.ear $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-app-openstack/oscm-app-openstack.ear $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-common/oscm-common.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-extsvc-internal/oscm-extsvc-internal.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-server-common/oscm-server-common.jar $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-extsvc/oscm-extsvc-platform.jar $REPO_DOCKER/oscm-app/

mkdir $REPO_DOCKER/oscm-app/sqlscripts
cp $REPO_OSCM/oscm-app/resources/sql/*.sql $REPO_DOCKER/oscm-app/sqlscripts/
