#!/bin/sh

Cyan='\033[1;35m'
White='\033[1;37m'
Red='\033[0;31m'

get_files() {
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/steps.sh
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/application-template.json
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

#get_files

. def/utils.sh
. def/handlers.sh
. def/application.sh
. def/user.sh

#Provide Azure AD credentials
echo -e -n "${Cyan}Enter an application (client) ID: ${White}"
read client_id < /dev/tty
echo -e -n "${Cyan}Enter a client secret of your application: ${White}"
read client_secret < /dev/tty
echo -e -n "${Cyan}Enter the tenant name in Azure AD: ${White}"
read tenant_name < /dev/tty

#Provide application properties
echo -e -n "${Cyan}Enter the display name of your application: ${White}"
read app_display_name < /dev/tty
echo -e -n "${Cyan}Enter the hostname of your application (used in redirect url when authenticating with Azure AD): ${White}"
read app_hostname < /dev/tty

install_jq

get_access_token

register_new_application $app_display_name $app_hostname

create_service_principal

create_application_secret

get_graph_api_id

grant_consent

prepare_properties_for_tenant
