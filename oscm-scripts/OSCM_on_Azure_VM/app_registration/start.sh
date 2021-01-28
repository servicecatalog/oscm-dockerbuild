#!/bin/bash

Cyan='\033[1;35m'
White='\033[1;37m'

get_files () {
  wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts//OSCM_on_Azure_VM/app_registration/steps.sh
  wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/application-template.json
  wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/response.json
  wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/rr_operations.sh
  wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/tenant-template.properties
}

#Provide Azure AD credentials
echo -e -n "${Cyan}Enter a application (client) ID: ${White}"
read client_id
echo -e -n "${Cyan}Enter a client secret: ${White}"
read client_secret
echo -e -n "${Cyan}Enter a directory (tenant) ID: ${White}"
read tenant_name

#Provide application properties
echo -e -n "${Cyan}Enter a directory (tenant) ID: ${White}"
read app_display_name
echo -e -n "${Cyan}Enter a directory (tenant) ID: ${White}"
read app_ip

get_files

. ./steps.sh

prepare_input

get_access_token

register_new_application

create_service_principal

create_application_secret

grant_consent

prepare_properties_for_tenant
