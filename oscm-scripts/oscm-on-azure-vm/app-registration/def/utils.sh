install_jq(){
  echo "START: Checking if jq is exist"
  dpkg -s jq &> /dev/null

  if [ $? -ne 0 ]; then
    sudo apt-get install -y jq
  else
    echo "Jq already installed"
  fi
}

get_access_token(){
  echo "START: Retrieving access token..." > output/output.logs
  auth_data="grant_type=client_credentials&scope=https://graph.microsoft.com/.default&client_id=$client_id&client_secret=$client_secret"
  auth_response=$(request_api "https://login.microsoftonline.com/$tenant_name/oauth2/v2.0/token" $auth_data)

  handle_response $auth_response

  access_token=$(get_from_response "access_token")
}

prepare_properties_for_tenant(){
  echo "START: Preparing tenant.properties..." >> output/output.logs
  sed -e "s/\${clientId}/$app_appId/" -e "s/\${clientSecret}/$secret/" -e "s/\${hostname}/$app_hostname/" -e "s/\${tenant}/$tenant_name/"  templates/tenant-template.properties > output/tenant-default.properties
  if [ $? -ne 0 ]; then
    echo "Tenant data preparation failed" >> output/output.logs
    exit 1
  else
    echo "Tenant data preparation was successful" >> output/output.logs

    echo -e "\n${Green}Application registered successfully in Azure Active Directory"
    echo -e "${Green}Tenant properties can be found in: ${White}output/tenant-default.properties ${Green} - Copy them to: ${White}/docker/config/oscm-identity/tenants\n"
  fi
}

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
