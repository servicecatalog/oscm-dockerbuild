#!/bin/sh

Cyan='\033[1;35m'
White='\033[1;37m'
Red='\033[0;31m'

build_dependencies() {
  echo "Checking dependencies..."
  #Download necessary scripts
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/utils.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/handlers.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/application.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/user.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/group.sh

  #Download necessary templates
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/tenant-template.properties
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/user-template.json
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/application-template.json
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/group-template.json

  #Create output diretory
  mkdir output

  if [ -f def/utils.sh -a -f def/handlers.sh -a -f def/application.sh -a -f def/user.sh -a -f def/group.sh -a -f templates/user-template.json -a -f templates/group-template.json -a -f templates/application-template.json -a -f templates/tenant-template.properties -a -d output ]; then
    echo "Dependencies are ready"
  else
    echo -e -n "${Red}Building dependencies failed!\n"
    echo -e -n "It is possible that the proxy is blocking access.${White}\n"
    echo -e -n "Configure your dependencies structure or download files manually from \n"
    echo "https://github.com/servicecatalog/oscm-dockerbuild/tree/master/oscm-scripts/OSCM_on_Azure_VM/app_registration"
    exit 1
  fi
}

build_dependencies

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
