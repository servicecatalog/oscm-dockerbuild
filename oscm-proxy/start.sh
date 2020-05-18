#!/bin/bash
htpasswd -b -c /etc/nginx/pwd/.htpasswd ${ADMIN_USER_ID} ${ADMIN_USER_PWD}
nginx -g daemon off