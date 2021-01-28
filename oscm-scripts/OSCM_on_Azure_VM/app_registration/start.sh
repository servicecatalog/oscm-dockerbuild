#!/bin/bash

Cyan='\033[1;35m'
White='\033[1;37m'

wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts//OSCM_on_Azure_VM/app_registration/steps.sh
wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/application-template.json
wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/response.json
wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/rr_operations.sh
wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/Task%23321_Add_scripts_for_setup_with_OIDC/oscm-scripts/OSCM_on_Azure_VM/app_registration/tenant-template.properties

. ./steps.sh

#Provide Azure AD credentials
read -p "${Cyan}Enter a application (client) ID: ${White}" client_id
read -p "${Cyan}Enter a client secret: ${White}" client_secret
read -p "${Cyan}Enter a directory (tenant) ID: ${White}" tenant_name

#Provide application properties
read -p "${Cyan}Enter a directory (tenant) ID: ${White}" app_display_name
read -p "${Cyan}Enter a directory (tenant) ID: ${White}" app_ip

prepare_input

get_access_token

register_new_application

create_service_principal

create_application_secret

grant_consent

prepare_properties_for_tenant
