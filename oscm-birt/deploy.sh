 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

#!/bin/bash
su -s /bin/bash -c 'source /etc/tomcat/tomcat.conf ; source /etc/sysconfig/tomcat ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/libexec/tomcat/server start' -g tomcat tomcat &
sleep 30 ; \
su -s /bin/bash -c 'source /etc/tomcat/tomcat.conf ; source /etc/sysconfig/tomcat ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/libexec/tomcat/server stop' -g tomcat tomcat &
