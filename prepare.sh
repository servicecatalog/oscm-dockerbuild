#!/bin/bash

REPO_DOCKER="`dirname \"$0\"`"
REPO_OSCM="$1"
BUILD_DIR="$REPO_OSCM/oscm-build/result/package"

# copy resources for bes
cp $BUILD_DIR/oscm-search/oscm-search.ear $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-ear/oscm.ear $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-ear/tmp/oscm.ear $REPO_DOCKER/oscm-bes/oscm-sso.ear
cp $BUILD_DIR/oscm-portal/oscm-portal.war $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-portal-help/oscm-portal-help.war $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-reports/oscm-reports.zip $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-bes/
cp $BUILD_DIR/oscm-security/oscm-security.jar $REPO_DOCKER/oscm-bes/
cp $REPO_OSCM/libraries/apache-codec/javalib/commons-codec-1.7.jar $REPO_DOCKER/oscm-bes/

mkdir $REPO_DOCKER/oscm-bes/sqlscripts/
cp $REPO_OSCM/oscm-devruntime/javares/sql/*.sql $REPO_DOCKER/oscm-bes/sqlscripts/

# copy resources for app
cp $BUILD_DIR/oscm-app-ear/oscm-app.ear $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-app-aws/oscm-app-aws.ear $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-app-openstack/oscm-app-openstack.ear $REPO_DOCKER/oscm-app/
cp $BUILD_DIR/oscm-devruntime/oscm-devruntime.jar $REPO_DOCKER/oscm-app/

mkdir $REPO_DOCKER/oscm-app/sqlscripts/
cp $REPO_OSCM/oscm-app/resources/sql/*.sql $REPO_DOCKER/oscm-app/sqlscripts/


