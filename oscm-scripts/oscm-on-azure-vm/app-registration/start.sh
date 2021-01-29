#!/bin/sh

Cyan='\033[1;35m'
White='\033[1;37m'

#Provide Azure AD credentials
echo -e -n "${Cyan}Enter a application (client) ID: ${White}"
read client_id < /dev/tty
echo -e -n "${Cyan}Enter a client secret: ${White}"
read client_secret < /dev/tty
echo -e -n "${Cyan}Enter a directory (tenant) ID: ${White}"
read tenant_name < /dev/tty

#Provide application properties
echo -e -n "${Cyan}Enter a your application register name: ${White}"
read app_display_name < /dev/tty
echo -e -n "${Cyan}Enter a your application IP: ${White}"
read app_ip < /dev/tty

. ./steps.sh

prepare_input

get_access_token

register_new_application

create_service_principal

create_application_secret

grant_consent

prepare_properties_for_tenant
