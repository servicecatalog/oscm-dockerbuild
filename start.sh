#!/bin/sh

Cyan='\033[1;35m'
White='\033[1;37m'

get_files() {
  sudo wget -e use_proxy=yes -e http_proxy=127.0.0.1:8080 https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts//OSCM_on_Azure_VM/app_registration/steps.sh
  sudo wget -e use_proxy=yes -e http_proxy=127.0.0.1:8080 wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/application-template.json
  sudo wget -e use_proxy=yes -e http_proxy=127.0.0.1:8080 wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/response.json
  sudo wget -e use_proxy=yes -e http_proxy=127.0.0.1:8080 wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/rr_operations.sh
  sudo wget -e use_proxy=yes -e http_proxy=127.0.0.1:8080 wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/tenant-template.properties
}

get_files

#Provide Azure AD credentials
echo -e -n "${Cyan}Enter a application (client) ID: ${White}"
read client_id < /dev/tty
echo -e -n "${Cyan}Enter a client secret: ${White}"
read client_secret < /dev/tty
echo -e -n "${Cyan}Enter a tenanst name (e-mail suffix): ${White}"
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
