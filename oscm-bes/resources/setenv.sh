#!/bin/sh
JAVA_OPTS=$JAVA_OPTS" -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"
JAVA_OPTS=$JAVA_OPTS" -Djava.security.auth.login.config=/opt/apache-tomee-plume-7.0.3/conf/jaas.config"
export JAVA_OPTS