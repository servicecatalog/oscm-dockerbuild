#!/bin/sh

 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************
 
JAVA_OPTS=$JAVA_OPTS" -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"
JAVA_OPTS=$JAVA_OPTS" -Djava.security.auth.login.config=/opt/apache-tomee/conf/jaas.config"

if [ -n "$JMX_REMOTE_PORT" ]; then 
  JAVA_OPTS=$JAVA_OPTS" -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$JMX_REMOTE_PORT -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
fi

export JAVA_OPTS
