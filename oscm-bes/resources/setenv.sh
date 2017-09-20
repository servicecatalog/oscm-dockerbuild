#!/bin/sh
JAVA_OPTS=" -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true -Djava.security.auth.login.config=/opt/apache-tomee-plume-7.0.3/conf/jaas.config "
export JAVA_OPTS
