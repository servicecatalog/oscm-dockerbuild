#!/bin/sh

Cyan='\033[1;35m'
White='\033[1;37m'
Red='\033[0;31m'

get_files() {
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/steps.sh
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/application-template.json
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/response.json
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/rr_operations.sh
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/tenant-template.properties

  if [ -f ./steps.sh ]; then
    echo "Downloading files was successful "
  else
    echo -e -n "${Red}Downloading files failed!\n"
    echo -e -n "It is possible that the proxy is blocking access.${White}\n"
    echo -e -n "Configure your settings or download files manually from \n"
    echo "https://github.com/servicecatalog/oscm-dockerbuild/tree/master/oscm-scripts/OSCM_on_Azure_VM/app_registration"
    exit 1
  fi
}

get_files

#Provide Azure AD credentials
echo -e -n "${Cyan}Enter a application (client) ID: ${White}"
read client_id < /dev/tty
echo -e -n "${Cyan}Enter a client secret: ${White}"
read client_secret < /dev/tty
echo -e -n "${Cyan}Enter a tenant name (e-mail suffix): ${White}"
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
