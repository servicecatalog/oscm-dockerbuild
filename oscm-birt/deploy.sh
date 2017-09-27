#!/bin/bash
su - tomcat -c 'source /etc/tomcat/tomcat.conf ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat-sysd start' &
sleep 30 ; \
su - tomcat -c 'source /etc/tomcat/tomcat.conf ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat-sysd stop' &
