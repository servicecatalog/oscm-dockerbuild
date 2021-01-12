#!/bin/bash
htpasswd -b -c /etc/nginx/pwd/.htpasswd ${MAIL_USER_NAME} ${MAIL_USER_PWD}
nginx -g "daemon off;"