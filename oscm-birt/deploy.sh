#!/bin/bash
su -s /bin/bash -c 'source /etc/tomcat/tomcat.conf ; source /etc/sysconfig/tomcat ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat start' -g tomcat tomcat &
sleep 30 ; \
su -s /bin/bash -c 'source /etc/tomcat/tomcat.conf ; source /etc/sysconfig/tomcat ; export CATALINA_BASE CATALINA_HOME CATALINA_TMPDIR ; /usr/sbin/tomcat stop' -g tomcat tomcat &
