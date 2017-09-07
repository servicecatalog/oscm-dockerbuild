#!/bin/sh
JAVA_OPTS="-Djava.security.auth.login.config=/opt/bes/apache-tomee-plume-7.0.3/conf/jaas.config -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"
export JAVA_OPTS