#!/bin/bash
su - tomcat -c 'source /etc/tomcat/tomcat.conf ; source /etc/sysconfig/tomcat ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/lib/tomcat/server start' &
sleep 30 ; \
su - tomcat -c 'source /etc/tomcat/tomcat.conf ; source /etc/sysconfig/tomcat ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/lib/tomcat/server stop' &
