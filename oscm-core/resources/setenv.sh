 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

#!/bin/sh
JAVA_OPTS=$JAVA_OPTS" -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"
JAVA_OPTS=$JAVA_OPTS" -Djava.security.auth.login.config=/opt/apache-tomee/conf/jaas.config"
export JAVA_OPTS
